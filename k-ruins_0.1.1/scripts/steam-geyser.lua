
-- register data
remote.call("k-monuments", "register_monument", {
  name = "steam-geyser",
  entity_name = "steam-geyser-bare",
  parent_mod_name = "k-ruins",
  position = {
    offset = { 300, 400 },
  },
  upgrades = {
    ["restored-steam-geyser"] = {
      entity_name = "steam-geyser-pump",
      attract_biters = {
        chance = { 0.0, 0.5 },
        cycle = 600,
        count = { 1, 10 },
      }
    }
  }
})

-- no events

-- no reveal

-- if the pump has created any water, make it 100 degrees
Event.register(defines.events.on_tick, function(event)
  local _entity = remote.call("k-monuments", "get_monument_entity", "steam-geyser")
  if _entity then
    if _entity.valid then
      for i = 1, #_entity.fluidbox do
        _entity.fluidbox[i].temperature = 100
      end
    end
  end
end)