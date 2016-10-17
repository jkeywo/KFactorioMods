
require("config")

-- std lib
require("stdlib.area.area")
require("stdlib.area.chunk")
require("stdlib.area.position")
require("stdlib.event.event")

-- data
local monument_data = {}
--{
--  name = "name",
--  entity_name = "entity", -- entity to create
--  default_floor = "stone-path", -- floor to create under the monument
--  position = {
--    center = { x=0, y=0 },      -- point around which to be generated
--    offset = { 100, 200 }, -- distance from the center
--    surface = "nauvis", -- surface to create it on, defaults to nauvis
--  },
--  restoration = {                     -- restoration behaviour, leave nil to disable
--    restored_entity_name = "entity-restored", -- entity to turn into once restorated
--    restored_item = "restored-entity", -- item required in the output inventory of the monument to restore
--    on_restored = function(entity) end, -- called when a monument is resotered
--    on_reverted = function(entity) end, -- called when a restored monument is destroyed
--    attract_biters = {                  -- should biters periodically attack the restored monument, leave nil to disable
--      chance = { 0.0, 1.0 },            -- chance of an attack, either a fixed chance or lerps with evolution
--      cycle = 300,                      -- seconds between attacks, either a fixed time or lerps with evolution
--      count = { 1, 30 },                -- biters per attack, either a fixed amountor lerps with evolution
--    }
--  }
--}

-- Functions
function lerp(range, t)
  if type(range) == "table" then
    return range[1] + ( t * (range[2] - range[1]) )
  elseif type(range) == "number" then
    return range
  end
  return nil
end

function position_from_data( data )
  --while not _global_data do
  -- resolve position to an actual position and store in global
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
    -- TODO check of position collides with another monument
    -- otherwise go for another trip around the loop
    return _position
  --end
  return nil
end

function get_surface( name_or_data )
  if type(name_or_data) == "string" then
    return game.surfaces[monument_data[name_or_data].position.surface or "nauvis"]
  else
    return game.surfaces[name_or_data.position.surface or "nauvis"]
  end
end

function get_global_data( name )
  global.momuments = global.momuments or {}
  if global.momuments[name] then
    return global.momuments[name]
  end
  
  local _data = monument_data[name]
  local _global_data = {
      generated = false,
      position = position_from_data( _data )
    }
  global.momuments[name] = _global_data
  return _global_data
end

function contains_monument( name, surface, area )
  local _global_data = get_global_data(name)
  local _position = _global_data.position
  local _surface = get_surface(name)
  if surface == _surface and Area.inside( area, _position ) then
    return true
  end
  return false
end

function place_monument( data )
  local _global_data = get_global_data(data.name)
  local _surface = get_surface(data)
  -- clear area of doodads and other entities
  local _surrounding_area = Position.expand_to_area( _global_data.position, 4 ) -- TODO entity.prototype.selection_box
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
  
  local _monument = _surface.create_entity {
    name = monument_data[data.name].entity_name, 
    position = _global_data.position, 
    force = game.players[1].force -- TODO fix force, make the entity claimable
  } 
  _monument.destructible = false
  _monument.rotatable = false
  _monument.minable = false
  
  global.momuments[data.name].generated = true
  global.momuments[data.name].restored = false
end

function register_momument( data )
  monument_data[data.name] = data
  get_global_data(data.name)
  
  -- place if already generated
  --local _surface = game.surfaces[monument_data[name].surface or "nauvis"]
  --if _surface.is_chunk_generated( global.momuments[data.name].position ) then
  --  place_monument( data )
  --end
end

function reveal_momument( name )
  if not monument_data[name] then
    return
  end
  if global.momuments[name].generated then
    return
  end
  local _surface = game.surfaces[monument_data[name].surface or "nauvis"]
  game.print( name.." has been revealed" )
  
  _surface.request_to_generate_chunks( Chunk.from_position( global.momuments[name].position ), 1 )
end

function restore_monument( name )
  local _data = monument_data[name]
  local _position = global.momuments[name].position
  local _surface = get_surface(name)
  local _force = game.player[1].force 
  
  -- destroy existing entity
  local _entity = _surface.find_entity( _data.entity_name, _position )
  if _entity then 
    _force = _entity.force
    _entity.destroy() 
  end
  
  -- replace with a new one
  local _new_entity = _surface.create_entity {
    name = _data.restoration.restored_entity_name, 
    position = _position, 
    force = _force
  }
  _data.on_restored(_new_entity)
  global.momuments[name].restored = true
  
  game.print( name.." has been restored" )
end

function ruin_monument( name )
  local _data = monument_data[name]
  local _position = global.momuments[name].position
  local _surface = get_surface(_data)
  local _entity = _surface.find_entity(_data.restoration.restored_entity_name, _position)
  if _entity then _entity.destroy() end

  local _new_entity = event.surface.create_entity {
    name = _data.entity_name, 
    position = _position, 
    force = game.player[1].force 
  }
  _monument.on_reverted(_new_entity)
  global.momuments[name].restored = false
  
  game.print( name.." has fallen to ruin" )
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
  for _, _monument in pairs(monument_data) do
    local _global_data = get_global_data(_monument)
    if _monument.restoration and _global_data.generated then
      if _global_data.restored then
        -- check to see if it's been destroyed
        local _position = _global_data.position
        local _surface = get_surface( _monument )
        local _entity = _surface.find_entity(_monument.restoration.restored_entity_name, _position)
        if not _entity then
          destroy_monument( _monument.name )
        end
      else
        -- check if restoring task is done, then restore
        local _entity = _surface.find_entity( _monument.entity_name, _position )
        if _entity and _entity.get_output_inventory() 
            and _entity.get_output_inventory().find_item_stack(_monument.restoration.restored_item) then
          restore_monument( _monument.name )
        end
      end
    end
  end
end)

-- Default Monuments
if Config.enable_default_momuments then
  require("default_monuments")
end

-- Script Interface
remote.add_interface("k_momuments", {
  register_momument = function( data )
    register_momument( data )
  end,
  reveal_momument = function( name )
    reveal_momument( name )
  end,
  restore_momument = function( name )
    restore_momument( name )
  end,
  ruin_momument = function( name )
    ruin_momument( name )
  end
 })


