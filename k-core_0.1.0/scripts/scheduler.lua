
Scheduler = {}

Scheduler.add_callback = function( delay, event_id, data, persistent )
  global.scheduler = global.scheduler or {}
  
  local _target_tick = game.tick + delay
  if global.scheduler[_target_tick] == nil then
    global.scheduler[_target_tick] = {}
  end
  global.scheduler[_target_tick][event_id] = { delay = delay, data = data, persistent = persistent }
end

Scheduler.remove_callback = function( event_id )
  global.scheduler = global.scheduler or {}
  for _, _callbacks in pairs(global.scheduler) do
    _callbacks[event_id] = nil
  end
end

Event.register( defines.events.on_tick, function(event)
  global.scheduler = global.scheduler or {}
  if global.scheduler[event.tick] then
    for _event_id, _data in pairs(global.scheduler[event.tick]) do
      game.raise_event(_event_id, _data.data)
      if _data.persistent then
        Scheduler.add_callback( _data.delay, _event_id, _data.data, _data.persistent )
      end
    end
    global.scheduler[event.tick] = nil
  end
end)