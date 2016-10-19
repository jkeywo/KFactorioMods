local scheduler = {}

local MAX_PENDING_TIME = 600

-- Public Functions
scheduler.add_to_scheduler = function(callback, data)
	local _current_pos = (game.tick+1) % MAX_PENDING_TIME
	table.insert( global["schedule"][_current_pos], { callback = callback, data = data } )
end

-- Events
Event.register( Event.core_events.init, function()
	global["schedule"] = global["schedule"] or {}
	for i = 0, MAX_PENDING_TIME-1 do
		global["schedule"][i] = global["schedule"][i] or {}
	end
end)

Event.register(defines.events.on_tick, function(event)
	local _current_pos = game.tick % MAX_PENDING_TIME
	local _schedule = global["schedule"]
	local _current_schedule = _schedule[_current_pos] or {}
	_schedule[_current_pos] = {}
	for _, _item in pairs(_current_schedule) do
		local wait_time = _item.callback(_item.data)
		if wait_time then
			wait_time = math.max(1, math.min(600, math.floor(wait_time)))
			local _queue_pos = (_current_pos + wait_time) % MAX_PENDING_TIME
			table.insert(_schedule[_queue_pos], _item)
		end
	end
end)

return scheduler