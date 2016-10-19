local M = {}

-- private functions
local function compare_link_data( dataA, dataB )
  return (dataA.name == dataB.name 
          and dataA.postion == dataB.postion 
          and dataA.surface == dataB.surface )
end

local function make_link_data( entity )
  return { 
      name = entity.name, 
      postion = entity.position, 
      surface = entity.surface.name
    }
end

local function get_linked_entity( data )
  return data.surface.find_entity( data.name, data.position )
end

local function add_link( entityA, entityB )
  local _data = Entity.get_data( entityA ) or {}
  _data.links = _data.links or {}
  local _new_data = make_link_data( entityB )
  if table.any(_data.links, function(a, _, b) return compare_link_data( a, b) end, _new_data) then
    return
  end
  _data.links[#_data.links+1] = _new_data
  Entity.set_data( entityA, _data )
end

-- public functions
M.pair = function( entityA, entityB )
  if entityA == entityB then
    return
  end
  add_link( entityA, entityB )
  add_link( entityB, entityA )
end

M.link = function( entities )
  for i = 1, #entities do
    for j = 1, #entities do
      if i ~= j then
        add_link( entities[i], entities[j] )
      end
    end
  end
end

M.get_linked_data = function( entity )
  local _data = Entity.get_data(entityA) or {}
  return _data.linked
end

M.get_linked_entities = function( entity )
  local _data = Entity.get_data(entityA) or {}
  local _links = _data.linked or {}
  local _ret = {}
  for _, _link in pairs(_links) do
    local _linked_entity = get_linked_entity(_link)
    if linked_entity then
      _ret[#_ret+1] = _linked_entity
    end
  end
  return _ret
end

M.create_and_pair = function( entity, pairedType, pairedSurface )
  pairedSurface.request_to_generate_chunks( Chunk.from_position(entity.position), 4)
  if pairedSurface.can_place_entity{ name = pairedType, position = entity.position } then
    local _paired_entity = _surface.create_entity { name = pairedType, position = entity.position, force=entity.force }
    M.pair( entity, _paired_entity )
    return _paired_entity
  end
  return nil
end

M.create_and_link = function( entity, pairedType, pairedSurfaces )
  local _entities = { entity }
  for _, _surface in pairs(pairedSurfaces) do
    if entity.surface ~= _surface then
      _surface.request_to_generate_chunks( Chunk.from_position(entity.position), 4)
      if _surface.can_place_entity{ name = pairedType, position = entity.position } then
        local paired_entity = _surface.create_entity { name = pairedType, position = entity.position, force=entity.force }
        _entities[#_entities+1] = paired_entity
      end
    end
  end
  M.link( _entities )
  return _entities
end

M.for_each_linked = function( entity, fn )
  local _data = Entity.get_data(entity) or {}
  local _paired_entities = _data.linked or {}
  for i = 1, #_paired_entities do
    local _paired_data = Entity.get_data(_paired_entities[i]) or {}
    if fn then
      fn( _paired_entities[i] )
    end
  end
end

M.unlink = function( entity, fn )
  local _data = Entity.get_data(entity) or {}
  local _paired_entities = _data.linked or {}
  for i = 1, #_paired_entities do
    local _paired_data = Entity.get_data(_paired_entities[i]) or {}
    table.merge(_paired_data, { linked = {} } )
    Entity.set_data(_paired_entities[i], _paired_data)
    if fn then
      fn( _paired_entities[i] )
    end
  end
  _data.linked = {}
  Entity.set_data(_data)
end

M.on_destroyed = function( entity )
  M.unlink( entity, function(entity) entity.destroy() end )
end

return M
