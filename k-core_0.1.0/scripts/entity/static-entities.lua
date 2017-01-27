
-- GLOBAL DATA
-- global.static_entities[ "name" ]
-- {
--    name = "",
--    entity_name = "",
--    position = { 0, 0 },
--    generated = false
-- }
local finalise_list = {}
local finalise_reveal_list = {}

-- Functions

StaticEntity = {
  data = {}
--["name"] = {
--  name = "name",
--  entity_name = "entity-name",      -- entity to create
--  default_floor = "stone-path",     -- floor to create under the static entity
--  flooring_area = 4,
--  position = {
--    center = { x=0, y=0 },          -- point around which to be generated
--    offset = { 100, 200 },          -- distance from the center
--    surface = "nauvis",             -- surface to create it on, defaults to nauvis
--  },
--}
}

StaticEntity.get_data = function( name_or_data )
  if type(name_or_data) == "string" then
    return StaticEntity.data[name_or_data]
  end
  return name_or_data
end

StaticEntity.get_global_data = function( name_or_data )
  global.monuments = global.monuments or {}
  local _data = StaticEntity.get_data( name_or_data )
  return global.monuments[_data.name]
end

StaticEntity.get_surface = function( name_or_data )
  local _data = StaticEntity.get_data( name_or_data )
  return game.surfaces[_data.position.surface or "nauvis"]
end

StaticEntity.get_entity = function( name_or_data )
  local _data = StaticEntity.get_data( name_or_data )
  local _global_data = _data:get_global_data()
  local _surface = _data:get_surface()
  return _surface.find_entity( _global_data.entity_name, _global_data.position )
end

StaticEntity.contains = function( name_or_data, surface, area )
  local _data = StaticEntity.get_data( name_or_data )
  local _global_data = _data:get_global_data()
  if not _global_data then game.print("ERROR: Missing global data in 'contains_monument'") return false end
  
  if surface == _data:get_surface() and Area.inside( area, _global_data.position ) then
    return true
  end
  return false
end

StaticEntity.place = function( name_or_data )
  local _data = StaticEntity.get_data( name_or_data )
  local _global_data = _data:get_global_data()
  if not _global_data then game.print("ERROR: Missing global data in 'place_monument'") return false end
  
  local _surface = _data:get_surface()
  local _surrounding_area = Position.expand_to_area( _global_data.position, _data.flooring_area or 4 )
  
  -- clear area of doodads and other entities
  local _obstructions = _surface.find_entities(_surrounding_area)
  for _, _obstruction in pairs(_obstructions) do
    if _obstruction and _obstruction.valid then 
      game.raise_event(defines.events.on_entity_died, {entity=_obstruction})
      _obstruction.destroy()
    end
  end
  -- place down the default flooring
  local _tile_table = {}
  local _floor_type = _data.default_floor or "stone-path"
  for x,y in Area.iterate( _surrounding_area ) do
    table.insert(_tile_table, { name = _floor_type, position = {x=x, y=y}} )
  end
  _surface.set_tiles(_tile_table)
  
  -- create the moument
  local _monument = _surface.create_entity {
    name = _data.entity_name, 
    position = _global_data.position, 
    force = game.players[1].force, -- TODO fix force, make the monuments claimable
  }
  game.raise_event(defines.events.on_built_entity, {created_entity=_monument, player_index=1})
  
  _global_data.generated = true
end

StaticEntity.register = function( data )
  setmetatable(data, {__index = StaticEntity})
  StaticEntity.data[data.name] = data
  finalise_list[ data.name ] = true
end

StaticEntity.finalise_registration = function( name_or_data )
  local _data = StaticEntity.get_data( name_or_data )
  global.monuments = global.monuments or {}
  if global.monuments[_data.name] then
    return
  end
  
  -- if there is no global data, initialise
  
  -- calculate position
  local _escape = 0
  local _final_position = nil
  while not _final_position and _escape < 100 do
    _escape = _escape + 1
    
    local _theta = math.random() * 2.0 * math.pi
    local _distance = lerp(_data.position.offset, math.random() )
    local _position = 
        { x = math.cos(_theta) * _distance,
          y = math.sin(_theta) * _distance
        }
    if _data.position.center then
      _position.x = _position.x + _data.position.center.x
      _position.y = _position.y + _data.position.center.y
    end
    -- check for collisions with other monuments (within 20 tiles)
    local _valid = true
    for _, _other_data in pairs(global.monuments) do
      if Position.distance_squared(_position, _other_data.position) < 400 then
        _valid = false
      end
    end
    if _valid then
      _final_position = _position
    end
  end
  if not _final_position then
    game.print("ERROR: Failed to register monument "..name..", could not find a valid position.")
    return
  end
  
  -- generate global data
  local _global_data = {
      generated = false,
      position = Tile.from_position(_final_position),
      entity_name = _data.entity_name
    }
  global.monuments[_data.name] = _global_data
  
  -- place if already generated
  local _surface = _data:get_surface()
  if _surface.is_chunk_generated( Chunk.from_position(_final_position) ) then
    _data:place()
  end
end

StaticEntity.reveal = function( name_or_data )
  local _data = StaticEntity.get_data( name_or_data )
  finalise_reveal_list[_data.name] = true
end

StaticEntity.finalise_reveal = function( name_or_data )
  local _data = StaticEntity.get_data( name_or_data )
  if not _data or not global.monuments[_data.name] then
    game.print("ERROR: Missing monument in 'reveal_monument'")
    return
  end
  if global.monuments[_data.name].generated then
    return
  end
 
  local _surface = _data:get_surface()
  local _chunk_position = Chunk.from_position( global.monuments[_data.name].position )
  _surface.request_to_generate_chunks( _chunk_position, 1 )

  for _, _force in pairs(game.forces) do
    _force.chart( _surface, Position.expand_to_area( global.monuments[_data.name].position, 16 ) )
  end

  game.print({"reveal-monument."..(_data.localised_name or _data.name)})
end

-- Events
Event.register(defines.events.on_chunk_generated, function(event)
  for _, _monument in pairs(StaticEntity.data) do
    if _monument:contains( event.surface, event.area ) then
      _monument:place()
    end
  end
end)

Event.register(defines.events.on_tick, function(event)
  -- TODO cache off current entity for static-entity
  for _name, _ in  pairs(finalise_list) do
    StaticEntity.finalise_registration( _name )
  end
  finalise_list = {}
  for _name, _ in  pairs(finalise_reveal_list) do
    StaticEntity.finalise_reveal( _name )
  end
  finalise_reveal_list = {}
end)
