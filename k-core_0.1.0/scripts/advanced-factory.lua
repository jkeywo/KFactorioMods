
AdvancedFactory = {
  data = {}
--  ["name"] = {
--    entity_name = "",
--    replacements = {
--      ["recipe_name"] = "entity_name"
--    }
--  }
}

AdvancedFactory.register = function(data)
  AdvancedFactory.data[data.entity_name] = data
end

AdvancedFactory.on_place = function(entity)
  if AdvancedFactory.data[entity.name] then
    global.advanced_factories = global.advanced_factories or {}
    global.advanced_factories[entity.unit_number] = { entity = entity, data_name = entity.name }
  end
end

AdvancedFactory.on_remove = function(data)
  global.advanced_factories = global.advanced_factories or {}
  if global.advanced_factories[entity.unit_number] then
    global.advanced_factories[entity.unit_number] = nil
  end
end

Event.register(defines.events.on_tick, function(event)
  global.advanced_factories = global.advanced_factories or {}
  for _, _entity_data in pairs(global.advanced_factories) then
    local _entity = _entity_data.entity
    local _data = AdvancedFactory.data[_entity_data.data_name]
    if _entity and _entity.valid and _entity.recipe then
      local _target_entity_name = _data.replacements[_entity.recipe.name] or _data.entity_name
      if _target_entity_name ~= _entity.name then
        _entity.surface.create_entity { name=_target_entity_name, position=_entity.position, direction=_entity.direction,
          force=_entity.force, fast_replace=true, spill=false, recipe=_entity.recipe }
      end
    end
  end
end)