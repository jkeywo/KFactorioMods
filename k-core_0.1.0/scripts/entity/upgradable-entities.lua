
-- GLOBAL
-- global.upgradables = { [entity.unit_number] = entity, } -- table of all upgradable entities

UpgradableEntity = {
  data = {},
--["entity-name"] = {
--  name="entity-name",
--  downgrade_to="previous-entity-name",
--  upgrades = { 
--    ["upgrade-item"] = "entity-name",
--    ["upgrade-item"2] = "entity-name2"
--  },
--}
}

-- Functions
UpgradableEntity.register = function( data )
  setmetatable(data, {__index = UpgradableEntity})
  UpgradableEntity.data[data.name] = data
end

UpgradableEntity.upgrade = function( data, entity, upgraded_type )
  -- cache off old data
  local _surface = entity.surface
  local _position = entity.position
  local _force = entity.force

game.print(upgraded_type)
game.print("-------------")

  -- clear data and destroy existing entity
  global.upgradables[entity.unit_number] = nil
  game.raise_event( defines.events.on_entity_died, { entity=entity, upgrading=true } )
  entity.destroy()
  
  -- replace with a new one
  local _new_entity = _surface.create_entity {
    name = upgraded_type,
    position = _position,
    force = _force
  }
  global.upgradables[_new_entity.unit_number] = _new_entity
  game.raise_event(defines.events.on_built_entity, {created_entity=_new_entity, player_index=1})
  
  game.print({"upgrade-entity."..(data.localised_name or data.name)})
end

UpgradableEntity.downgrade = function( data, entity )
  -- cache off old data
  local _name = entity.name
  local _surface = entity.surface
  local _position = entity.position
  local _force = entity.force

 -- clear data and destroy existing entity
  global.upgradables[entity.unit_number] = nil
  game.raise_event( defines.events.on_entity_died, { entity=entity, downgrading=true } )
  entity.destroy()
  
  local _new_entity = nil
  if data.downgrade_to then
    _new_entity = _surface.create_entity {
      name = data.downgrade_to, 
      position = _position,
      force = _force
    }
    global.upgradables[_new_entity.unit_number] = _new_entity
    game.raise_event(defines.events.on_built_entity, {created_entity=_new_entity, player_index=1})
  end

  game.print({"downgrade-entity."..(data.localised_name or data.name)})
end

-- Events
Event.register(defines.events.on_tick, function(event)
  global.upgradables = global.upgradables or {}
  for _, _entity in pairs(global.upgradables) do
    -- check if upgrade item is in our inventory
    if _entity and _entity.get_output_inventory() then
      local _data = UpgradableEntity.data[_entity.name]
      if _data.upgrades then
        for _item_name, _new_entity in pairs(_data.upgrades) do
          if _entity.valid and _entity.get_output_inventory().find_item_stack(_item_name) then
            _data:upgrade( _entity, _new_entity )
          end
        end
      end
    end
  end
end)

-- on create add to upgradable list and set type by data
Event.register( { defines.events.on_built_entity, 
                  defines.events.on_robot_built_entity }, function(event)
  if not event.created_entity or not event.created_entity.valid then return end
  local _data = UpgradableEntity.data[event.created_entity.name]
  if _data then
    global.upgradables = global.upgradables or {}
    global.upgradables[event.created_entity.unit_number] = event.created_entity
  end  
end)

Event.register(defines.events.on_entity_died, function(event)
  if event.upgrading or event.downgrading then return end
  
  local _data = UpgradableEntity.data[event.entity.name]
  if _data then
    _data:downgrade(event.entity)
  end
end)

Event.register({defines.events.on_preplayer_mined_item,
                  defines.events.on_robot_pre_mined}, function(event)
  if not event.entity.unit_number then return end
  
  global.upgradables = global.upgradables or {}
  global.upgradables[event.entity.unit_number] = nil
end)
