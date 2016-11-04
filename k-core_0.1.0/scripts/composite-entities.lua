
CompositeEntities = {
  data = {}
-- [""} = {
--    base_entity = "",
--    component_entities = 
--    {
--      entity_name = "",
--      offset = { x=0, y=0 },
--      operable=false,
--      lable="train-stop-name"
--    }
-- }
}

-- global.composite_entities = { { type="name", entity_list = {} } }
-- global.composite_entity_parent = { [entity] = parent_index }

local function rotate_offset( offset, direction )
  offset = Position.to_table( offset )
  if direction == defines.direction.north	then
    return { offset.x, offset.y }
  elseif direction == defines.direction.east then
    return { offset.y, -offset.x }
  elseif direction == defines.direction.south then
    return { -offset.x, -offset.y }
  elseif direction == defines.direction.west then
    return { -offset.y, offset.x }
  end
  return offset
end

CompositeEntities.register_composite = function( data )
  setmetatable(data, {__index = CompositeEntities})
  CompositeEntities.data[data.base_entity] = data
end

CompositeEntities.create_linked = function(entity)
  global.composite_entity_parent = global.composite_entity_parent or {}
  global.composite_entities = global.composite_entities or {}
  
  -- record base entity
  local _data = CompositeEntities.data[entity.name]
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
        name = _child.entity_name,
        direction  = _direction,
        surface = _surface,
        position = Tile.from_position( Position.add( _position, rotate_offset( _child.offset, _direction ) ) ),
        force = _force
      }
      if _child.operable ~= nil then _new_child.operable = _child.operable end
      if _child.lable ~= nil and _new_child.supports_backer_name() then _new_child.backer_name = _child.lable end
      
      table.insert( _new_global.entity_list, _new_child )
      global.composite_entity_parent[_new_child.unit_number] = _new_global_index
    end
    
    global.composite_entities[_new_global_index] = _new_global
    return _new_global.entity_list
  end
  return { entity }
end

CompositeEntities.destroy_linked = function(entity)
  global.composite_entity_parent = global.composite_entity_parent or {}
  global.composite_entities = global.composite_entities or {}
  
  local _parent_index = global.composite_entity_parent[entity.unit_number]
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
  CompositeEntities.create_linked( event.created_entity )
end)

-- event - on destroyed/mined
Event.register({
      defines.events.on_preplayer_mined_item,
      defines.events.on_robot_pre_mined,
      defines.events.on_entity_died,
    }, function(event)
  CompositeEntities.data.destroy_linked( event.entity )
end)
