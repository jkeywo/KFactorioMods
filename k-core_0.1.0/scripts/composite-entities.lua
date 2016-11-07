
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
    
    if _data.keep_cluster == nil then _data.keep_cluster = true end
    
    if _data.destroy_origional == nil then _data.destroy_origional = true end
    if _data.destroy_origional then
      entity.destroy()
    elseif _data.keep_cluster then
      table.insert( _new_global.entity_list, entity )
      global.composite_entity_parent[entity.unit_number] = _new_global_index
    end
    
    for _, _child in pairs(_data.component_entities) do
      local _child_name = _child.entity_name
      if type(_child_name) == "table" then
        _child_name = _child_name[math.random(1, #_child_name)]
      end
      
      local _offset = _child.offset and Position.to_table(_child.offset) or { x=0, y=0 }
      if _child.offset_area then
        _child.offset_area = Area.to_table(_child.offset_area)
        _offset.x = _offset.x + _child.offset_area.left_top.x + (math.random() * (_child.offset_area.right_bottom.x - _child.offset_area.left_top.x))
        _offset.y = _offset.y + _child.offset_area.left_top.y + (math.random() * (_child.offset_area.right_bottom.y - _child.offset_area.left_top.y))
      end
      
      local _position = Tile.from_position( Position.add( _position, rotate_offset( _offset, _direction ) ) )
      if not _child.can_fail or _surface.can_place_entity({ name = _child_name, direction  = _direction, position = _position, force = _force }) then
        local _new_child = _surface.create_entity { 
          name = _child_name,
          direction  = _direction,
          surface = _surface,
          position = _position,
          force = _force
        }
        if _child.operable ~= nil then _new_child.operable = _child.operable end
        if _child.lable ~= nil and _new_child.supports_backer_name() then _new_child.backer_name = _child.lable end
        
        if _data.keep_cluster then
          table.insert( _new_global.entity_list, _new_child )
          global.composite_entity_parent[_new_child.unit_number] = _new_global_index
        end
      end
    end
    
    if _data.keep_cluster then
      global.composite_entities[_new_global_index] = _new_global
    end
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
      defines.events.on_trigger_created_entity
    }, function(event)
  if event.created_entity then
    CompositeEntities.create_linked( event.created_entity )
  elseif event.entity then
    CompositeEntities.create_linked( event.entity )
  end
end)

-- event - on destroyed/mined
Event.register({
      defines.events.on_preplayer_mined_item,
      defines.events.on_robot_pre_mined,
      defines.events.on_entity_died,
    }, function(event)
  CompositeEntities.destroy_linked( event.entity )
end)
