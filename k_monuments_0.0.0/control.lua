
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
--  distance = { 100, 200 }, -- distance form the starting zone
--  surface = "nauvis", -- surface to create it on, defaults to nauvis
--  entity_name = "entity", -- entity to create
--  default_floor = "stone-path", -- floor to create under the monument
--  use_renovation_behaviour = true, -- should it use the renovation behaviour?
--  renovated_entity_name = "entity-restored", -- entity to turn into once revovated
--  renovate_item = "restored-entity", -- item required in the output inventory of the monument to restore
--  on_restored = function(entity) end, -- called when a monument is resotered
--  on_reverted = function(entity) end -- called when a restored monument is destroyed
--}

-- Functions
local function register_momument( data )
  monument_data[data.name] = monument_data
  
  global.momuments = global.momuments or {}
  while not global.momuments[data.name] do
  -- resolve position to an actual position and store in global
    local _theta = math.random() * 2.0 * math.pi
    local _distance = data.distance[1] + ( math.random() * (data.distance[2] - data.distance[1]) )
    local _position = 
        { x = math.cos(_theta) * _distance,
          y = math.sin(_theta) * _distance
        }
    -- TODO check of position collides with another monument
    -- otherwise go for another trip around the loop
    global.momuments[data.name] = {
        generated = false,
        position = _position
      }
  end
end

local function reveal_momument( name )
  if not monument_data[name] then
    return
  end
  if global.momuments[.name].generated then
    return
  end
  local _surface = game.surfaces[monument_data[name].surface or "nauvis"]
  game.print( name.." has been revealed" )
  _surface.request_to_generate_chunks( monument_data[name].position, 1 )
end

local function restore_monument( name )
  local _data = monument_data[name]
  local _position = global.momuments[name].position
  local _surface = game.surfaces[_data.surface or "nauvis"]
  local _entity = _surface.find_entity(_data.entity_name, _position)
  if _entity then _entity.destroy() then
  
  local _new_entity = _surface.create_entity {
    name = _data.renovated_entity_name, 
    position = _position, 
    force= game.player[1].force 
  }
  _data.on_restored(_new_entity)
  global.momuments[name].restored = true
end

local function ruin_monument( name )
  local _data = monument_data[name]
  local _position = global.momuments[name].position
  local _surface = game.surfaces[_data.surface or "nauvis"]
  local _entity = _surface.find_entity(_data.renovated_entity_name, _position)
  if _entity then _entity.destroy() then

  local _new_entity = event.surface.create_entity {
    name = _data.entity_name, 
    position = _position, 
    force=game.player[1].force 
  }
  _monument.on_reverted(_new_entity)
  global.momuments[name].restored = false
end

-- Events
Event.register(defines.events.on_chunk_generated, function(event)
  for _, _monument in pairs(monument_data) do
    local _position = global.momuments[_monument.name].position
    local _surface = game.surfaces[monument_data[name].surface or "nauvis"]
    if Area.inside( event.area, _position ) and events.surface == _surface then
      -- clear area of doodads and other entities
      local _surrounding_area = Position.expand_to_area( _position, 4 ) -- TODO entity.prototype.selection_box
      local _obstructions = event.surface.find_entities(_surrounding_area)
      for _, _obstruction in pairs(_obstructions) do
        _obstruction.destroy()
      end
      -- place down the default flooring
      local _tile_table = {}
      local _floor_type = _monument.default_floor or "stone-path"
      for _, _tile_pos in pairs(Area.iterate(_surrounding_area)) do
        table.insert(_tile_table, { name = _floor_type, position = _tile_pos} )
      end
      event.surface.set_tiles(_tile_table)
      
      -- TODO fix force, make the entity claimable
      local _monument = event.surface.create_entity {
        name = monument_data[_monument.name].entity_name, 
        position = _position, 
        force=game.player[1].force 
      } 
      _monument.destructible = false
      _monument.rotatable = false
      _monument.minable = false
      
      global.momuments[_monument.name].generated = true
      global.momuments[_monument.name].restored = false
    end
  end
end)

Event.register(defines.events.on_tick, function(event)
  for _, _monument in pairs(monument_data) do
    if _monument.use_renovation_behaviour 
        and global.momuments[_monument.name].generated then
      if global.momuments[_monument.name].restored then
        -- check to see if it's been destroyed
        local _position = global.momuments[.name].position
        local _surface = game.surfaces[monument_data[name].surface or "nauvis"]
        local _entity = _surface.find_entity(_monument.renovated_entity_name, _position)
        if not _entity then
          destroy_monument( _monument.name )
        end
      else
        -- check if restoring task is done, then restore
        local _entity = _surface.find_entity(_monument.entity_name, _position)
        if _entity and _entity.get_output_inventory() 
            and _entity.get_output_inventory().find_item_stack(_monument.renovate_item) then
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


