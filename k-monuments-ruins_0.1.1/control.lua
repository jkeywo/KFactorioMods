require("stdlib.event.event")

-- stores event callbacks
event_callbacks = {}

require("ruins.pyramid-control")
require("ruins.statue-control")
require("ruins.temple-control")
require("ruins.tree-control")
require("ruins.silo-control")
require("ruins.munitions-control")
require("ruins.steam-control")

-- message handling from "k-monuments"
Event.register(defines.events.on_tick, function(event)
  local _event_queue = remote.call( "k-monuments", "get_events", "k-monuments-ruins" )
  if not _event_queue then return end
  for _, _event in pairs(_event_queue) do
    if event_callbacks[_event.name] and event_callbacks[_event.name][_event.type] then
      event_callbacks[_event.name][_event.type](_event)
    end
  end
  remote.call( "k-monuments", "clear_events", "k-monuments-ruins" )
end)
