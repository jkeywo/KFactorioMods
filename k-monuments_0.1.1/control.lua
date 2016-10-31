
-- std lib
require("stdlib.area.area")
require("stdlib.area.chunk")
require("stdlib.area.position")
require("stdlib.event.event")

-- data
local monument_data = {}
--{
--  name = "name",
--  parent_mod_name = "k-monuments",
--  entity_name = "entity-name",      -- entity to create
--  default_floor = "stone-path",     -- floor to create under the monument
--  flooring_area = 4,
--  position = {
--    center = { x=0, y=0 },          -- point around which to be generated
--    offset = { 100, 200 },          -- distance from the center
--    surface = "nauvis",             -- surface to create it on, defaults to nauvis
--  },
--  upgrades = {                      -- upgrades, leave nil to disable
--    ["upgrade-entity"] = {          -- item required in the output inventory of the monument to upgrade
--      entity_name = "entity-mk2",   -- entity to turn into once restorated
--      attract_biters = {            -- should biters periodically attack the restored monument, leave nil to disable
--        chance = { 0.0, 1.0 },      -- chance of an attack, either a fixed chance or lerps with evolution
--        cycle = 300,                -- seconds between attacks, either a fixed time or lerps with evolution
--        count = { 1, 30 },          -- biters per attack, either a fixed amountor lerps with evolution
--      }
--    }
--  }
--}
local finalise_list = {}
local finalise_reveal_list = {}

-- Functions
local function lerp(range, t)
  if type(range) == "table" then
    return range[1] + ( t * (range[2] - range[1]) )
  elseif type(range) == "number" then
    return range
  end
  return nil
end

local function queue_event(monument_data, event_data)
  if monument_data and monument_data.parent_mod_name then
    global.event_queue = global.event_queue or {}
    global.event_queue[monument_data.parent_mod_name] = global.event_queue[monument_data.parent_mod_name] or {}
    table.insert( global.event_queue[monument_data.parent_mod_name], event_data)
  end
end

local function get_monument_surface( name_or_data )
  if type(name_or_data) == "string" then
    return game.surfaces[monument_data[name_or_data].position.surface or "nauvis"]
  else
    return game.surfaces[name_or_data.position.surface or "nauvis"]
  end
end

local function get_monument_entity( name )
  local _global_data = global.monuments[name]
  local _surface = get_monument_surface(name)
  return _surface.find_entity( _global_data.entity_name, _global_data.position )
end
local function contains_monument( name, surface, area )
  local _global_data = global.monuments[name]
  if not _global_data then game.print("ERROR: Missing global data in 'contains_monument'") return false end
  if surface == get_monument_surface(name) and Area.inside( area, _global_data.position ) then
    return true
  end
  return false
end

local function place_monument( data )
  local _global_data = global.monuments[data.name]
  if not _global_data then game.print("ERROR: Missing global data in 'contains_monument'") return false end
  
  local _surface = get_monument_surface(data)
  local _surrounding_area = Position.expand_to_area( _global_data.position, data.flooring_area or 4 )
  
  -- clear area of doodads and other entities
  local _obstructions = _surface.find_entities(_surrounding_area)
  for _, _obstruction in pairs(_obstructions) do
    _obstruction.destroy()
  end
  -- place down the default flooring
  local _tile_table = {}
  local _floor_type = data.default_floor or "stone-path"
  for x,y in Area.iterate( _surrounding_area ) do
    table.insert(_tile_table, { name = _floor_type, position = {x=x, y=y}} )
  end
  _surface.set_tiles(_tile_table)
  
  -- create the moument
  local _monument = _surface.create_entity {
    name = monument_data[data.name].entity_name, 
    position = _global_data.position, 
    force = game.players[1].force, -- TODO fix force, make the monuments claimable
  } 
  _monument.destructible = false
  _monument.rotatable = false
  _monument.minable = false
  
  _global_data.generated = true
  
  queue_event( data, {
    type = "placed",
    name = data.name,
    entity = _monument
    })

end

local function register_monument( data )
  monument_data[data.name] = data
  finalise_list[ data.name ] = true
end

local function finalise_registration( name )
  local _data = monument_data[name]
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
      position = _final_position,
      upgrade = nil,
      entity_name = _data.entity_name
    }
  global.monuments[name] = _global_data
  
  -- place if already generated
  local _surface = get_monument_surface(_data)
  if _surface.is_chunk_generated( Chunk.from_position(_final_position) ) then
    place_monument( _data )
  end
end

local function reveal_monument( name )
  finalise_reveal_list[name] = true
end

local function finalise_reveal( name )
  if not monument_data[name] or not global.monuments[name] then
    game.print("ERROR: Missing monument in 'reveal_monument'")
    return
  end
  if global.monuments[name].generated then
    return
  end
 
  local _surface = get_monument_surface(name)
  local _chunk_position = Chunk.from_position( global.monuments[name].position )
  _surface.request_to_generate_chunks( _chunk_position, 1 )

  for _, _force in pairs(game.forces) do
    _force.chart( _surface, Chunk.to_area(_chunk_position) )
  end

  game.print({"reveal-monument."..name})
end

local function upgrade_monument( name, upgrade_name )
  local _data = monument_data[name]
  local _global_data = global.monuments[name]
  if not _data or not _data.upgrades or not _data.upgrades[upgrade_name] then
    game.print("ERROR: No valid upgrade found for monument "..name.." (target "..upgrade_name..")")
    return
  end
  
  local _surface = get_monument_surface(_data)
  local _force = game.players[1].force
  
  -- destroy existing entity
  local _entity = _surface.find_entity( _data.entity_name, _global_data.position )
  if _entity then 
    _force = _entity.force
    _entity.destroy() 
  end
  
  local _upgrade_data = _data.upgrades[upgrade_name]
  -- replace with a new one
  local _new_entity = _surface.create_entity {
    name = _upgrade_data.entity_name,
    position = _global_data.position,
    force = _force
  }
  _new_entity.rotatable = false
  _new_entity.minable = false
  _global_data.upgrade = upgrade_name
  _global_data.entity_name = _upgrade_data.entity_name

  -- queue an event
  queue_event( _data, {
        type = "upgrade",
        name = name,
        entity = _new_entity
      })
    
  if _upgrade_data.attract_biters then
    _global_data.attract_biters_at = game.tick + lerp( _upgrade_data.attract_biters.cycle, game.evolution_factor )
  else
    _global_data.attract_biters_at = nil
  end
  
  game.print({"upgrade-monument."..name})
end

local function downgrade_monument( name )
  local _global_data = global.monuments[name]

  local _data = monument_data[name]
  local _surface = get_monument_surface(name)
  local _force = game.players[1].force
  
  local _entity = _surface.find_entity( _global_data.entity_name, _global_data.position )
  if _entity then
    _force = _entity.force
    _entity.destroy()
  end
  
  local _new_entity = nil
  _new_entity = _surface.create_entity {
    name = monument_data[name].entity_name, 
    position = _global_data.position,
    force = _force
  }
  _new_entity.destructible = false
  _new_entity.rotatable = false
  _new_entity.minable = false

  _global_data.upgrade = nil
  _global_data.entity_name = _data.entity_name
  _global_data.attract_biters_at = nil

  queue_event( _data, {
    type = "downgrade",
    name = name,
    entity = _new_entity
    })
  
  game.print({"downgrade-monument."..name})
end

-- Events
Event.register(defines.events.on_chunk_generated, function(event)
  for _, _monument in pairs(monument_data) do
    if contains_monument( _monument.name, event.surface, event.area ) then
      place_monument( _monument )
    end
  end
end)

Event.register(defines.events.on_tick, function(event)
    -- TODO cache off current entity for monument
  for _name, _ in  pairs(finalise_list) do
    finalise_registration( _name )
  end
  finalise_list = {}
  for _name, _ in  pairs(finalise_reveal_list) do
    finalise_reveal( _name )
  end
  finalise_reveal_list = {}

  for _, _monument in pairs(monument_data) do
    local _global_data = global.monuments[_monument.name]
    if _global_data and _global_data.generated and _monument.upgrades then
      -- check to see if it's been destroyed
      local _position = _global_data.position
      local _surface = get_monument_surface( _monument )
      local _entity = _surface.find_entity(_global_data.entity_name, _position)
      if not _entity then
        downgrade_monument( _monument.name )
      else
        -- check if upgrade item is in our inventory
        if _entity and _entity.get_output_inventory() then
          for _item_name, _ in pairs(_monument.upgrades) do
            if _entity.valid and _entity.get_output_inventory().find_item_stack(_item_name) then
              upgrade_monument( _monument.name, _item_name )
            end
          end
        end
      end
    end
    if _global_data and _global_data.attract_biters_at == game.tick then
      local _biter_data = _monument.upgrades[_global_data.upgrade].attract_biters
      
      if lerp( _biter_data.chance, game.evolution_factor ) > math.random() then
        local _surface = get_monument_surface( _monument )
        local _entity = _surface.find_entity(_global_data.entity_name, _global_data.position)

        local _unit_count = lerp( _biter_data.count, game.evolution_factor )
 				_surface.set_multi_command{command = {type=defines.command.attack, target=_entity, distraction=defines.distraction.by_enemy},unit_count = _unit_count, unit_search_distance = 600}
      end
      _global_data.attract_biters_at = game.tick + lerp( _biter_data.cycle, game.evolution_factor )
    end
  end
end)

Event.register(defines.events.on_entity_died, function(event)
  -- downgrade
  -- TODO cache off current monument for entity
  -- downgrade_monument( "" )
end)

-- Script Interface
remote.add_interface("k-monuments", {
  register_monument = function( data )
    register_monument( data )
  end,
  reveal_monument = function( name )
    reveal_monument( name )
  end,
  upgrade_monument = function( name )
    upgrade_monument( name )
  end,
  downgrade_monument = function( name )
    downgrade_monument( name )
  end,
  get_monument_entity = function( name )
    return get_monument_entity( name )
  end,
  get_monument_data = function( name )
    return monument_data[name]
  end,
  get_global_data = function( name )
    return global.monuments[name]
  end,
  get_events = function( parent_mod_name )
    global.event_queue = global.event_queue or {}
    return global.event_queue[parent_mod_name]
  end,
  clear_events = function( parent_mod_name )
    global.event_queue = global.event_queue or {}
    global.event_queue[parent_mod_name] = nil
  end
 })


