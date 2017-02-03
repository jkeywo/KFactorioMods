
EntityEvent = {
  data = {}
--["entity-name"] = {
--  name = "entity-name",
--  parent_mod_name = "k-monuments",
--  attract_biters = {            -- should biters periodically attack the restored monument, leave nil to disable
--    chance = { 0.0, 1.0 },      -- chance of an attack, either a fixed chance or lerps with evolution
--    cycle = 300,                -- seconds between attacks, either a fixed time or lerps with evolution
--    count = { 1, 30 },          -- biters per attack, either a fixed amountor lerps with evolution
--  },
--  on_placed = nil,              -- event handler, called when created
--  on_tick = nil,                -- event handler, called while this upgrade is active
--  on_removed = nil,             -- event handler, called if destroyed
--}
}

-- global.entityevents["entity-name"][_entity.unit_number] = _entity

EntityEvent.get_data = function( name_or_data )
  if type(name_or_data) == "string" then
    return EntityEvent.data[name_or_data]
  end
  return name_or_data
end

EntityEvent.get_global_data = function( name_or_data )
  global.entityevents = global.entityevents or { entities = {} }
  local _data = EntityEvent.get_data( name_or_data )
  return global.entityevents[_data.name]
end

EntityEvent.register = function( data )
  setmetatable(data, {__index = EntityEvent})
  EntityEvent.data[data.name] = data
end

-- Events
Event.register(defines.events.on_tick, function(event)
  for _name, _event in pairs(EntityEvent.data) do
    local _global_data = _event:get_global_data()
    if _event.on_tick then
      for _, _entity in pairs(_global_data.entities) do
        -- on_tick event
        game.raise_event(_event.on_tick, { entity = _entity } )
      end
    end
    if _global_data and _event.attract_biters and not _global_data.attract_biters_at then
      _global_data.attract_biters_at = game.tick
    end
    if _global_data and _global_data.attract_biters_at == game.tick then
      local _biter_data = _event.attract_biters
      for _, _entity in pairs(_global_data.entities) do
        -- attract biters
        if lerp( _biter_data.chance, game.evolution_factor ) > math.random() then
          local _unit_count = lerp( _biter_data.count, game.evolution_factor )
          _entity.surface.set_multi_command{command = {type=defines.command.attack, target=_entity, distraction=defines.distraction.by_enemy},unit_count = _unit_count, unit_search_distance = 600}
        end
      end
      global.entityevents[_name].attract_biters_at = game.tick + lerp( _biter_data.cycle, game.evolution_factor )
    end
  end
end)

Event.register( { defines.events.on_built_entity, 
                  defines.events.on_robot_built_entity }, function(event)
  if not event.created_entity or not event.created_entity.valid then return end
                  
  local _data = EntityEvent.get_data( event.created_entity.name  )
  if _data then
    global.entityevents = global.entityevents or {}
    global.entityevents[_data.name] = global.entityevents[_data.name] or { entities = {} }
    global.entityevents[_data.name].entities[event.created_entity.unit_number] = event.created_entity
  end
end)
Event.register( { defines.events.on_entity_died, 
                  defines.events.on_preplayer_mined_item,
                  defines.events.on_robot_pre_mined}, function(event)
  local _data = EntityEvent.get_data( event.entity.name  )
  if _data then
    global.entityevents = global.entityevents or {}
    global.entityevents[_data.name] = global.entityevents[_data.name] or { entities = {} }
    global.entityevents[_data.name].entities[event.entity.unit_number] = nil
  end
end)


