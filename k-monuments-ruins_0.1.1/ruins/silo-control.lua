
-- register data
remote.call("k-monuments", "register_monument", {
    name = "rocket-silo",
    entity_name = "rocket-silo-vines",
    parent_mod_name = "k-monuments-ruins",
    position = {
      offset = { 500, 700 },
    },
    upgrades = {
      ["restored-silo"] = {
        entity_name = "rocket-silo"
      }
    }
  })

-- no events

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  if event.research.name == "rocket-silo" then
    remote.call("k-monuments", "reveal_monument", "rocket-silo")
  end
end)
