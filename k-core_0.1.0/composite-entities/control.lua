
require("stdlib.area.position")
require("stdlib.event.event")

local composite_entities = {}
-- {
--    base_entity = "",
--    component_entities = 
--    {
--      entity_name = "",
--      offset = { x=0, y=0 }
--    }
-- }
-- global.composite_entities = { { type="name", entity_list = {} } }
-- global.composite_entity_parent = { [entity] = parent_index }

local function rotate_offset( offset, direction )
  offset = Position.to_table( offset )
  if direction == defines.direction.north	then
    return { -offset.x, -offset.y }
  elseif direction == defines.direction.east then
    return { offset.y, -offset.x }
  elseif direction == defines.direction.south then
    return { -offset.x, -offset.y }
  elseif direction == defines.direction.west then
    return { -offset.y, offset.x }
  end
  return offset
end

local function register_composite( data )
  composite_entities[data.base_entity] = data
end

local function create_linked(entity)
  global.composite_entity_parent = global.composite_entity_parent or {}
  global.composite_entities = global.composite_entities or {}
  
  -- record base entity
  local _data = composite_entities[entity.name]
  if _data then
    local _new_global = { type = entity.name, entity_list = {} }
    local _new_global_index = (#global.composite_entities) + 1
    local _surface = entity.surface
    local _position = entity.position
    local _direction = entity.direction
    local _force = entity.force
    entity.destroy()
    for _, _child in pairs(_data.component_entities) do
      local _new_child = _surface.create_entity { 
        name = _child.name,
        direction  = _direction,
        surface = _surface,
        position = Position.add( _position, rotate_offset( _child.offset, _direction ) ),
        force = _force
      }
      table.insert( _new_global.entity_list, _new_child )
      global.composite_entity_parent[_new_child] = _new_global_index
    end
    global.composite_entities[_new_global_index] = _new_global
  end
end

local function destroy_linked(entity)
  global.composite_entity_parent = global.composite_entity_parent or {}
  global.composite_entities = global.composite_entities or {}
  
  local _parent_index = global.composite_entity_parent[entity]
  if not _parent_index then return end
  local _parent = global.composite_entities[_parent_index]
  if not _parent then return end
  
  for _, _entity in pairs(_parent.entity_list) do
    if _entity ~= entity then
      global.composite_entity_parent[_entity] = nil
      _entity.destroy()
    end
  end
  global.composite_entity_parent[entity] = nil
  global.composite_entities[_parent_index] = nil
end

-- event - on created
Event.register({
      defines.events.on_built_entity,
      defines.events.on_robot_built_entity,
    }, function(event)
  create_linked( event.created_entity )
end)

-- event - on destroyed/mined
Event.register({
      defines.events.on_preplayer_mined_item,
      defines.events.on_robot_pre_mined,
      defines.events.on_entity_died,
    }, function(event)
  destroy_linked( event.entity )
end)

remote.add_interface( "k-composite-entities", {
    register_composite = function( data )
      register_composite( data )
    end,
    get_linked_entities = function( entity )
      return global.composite_entity_parent[entity].entity_list
    end,
    get_composite_data = function( entity )
      return composite_entities[ global.composite_entity_parent[entity].type ]
    end,
    on_create = function( entity )
      create_linked( entity )
    end,
    on_destroyed = function( entity )
      destroy_linked( entity )
    end,
  })