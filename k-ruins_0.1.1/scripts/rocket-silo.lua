
-- register data
remote.call("k-monuments", "register_monument", {
    name = "rocket-silo",
    entity_name = "rocket-silo-vines",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 500, 700 },
    },
    upgrades = {
      ["restored-silo"] = {
        entity_name = "rocket-silo"
      }
    }
  })

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "rocket-silo-vines",
      component_entities = {
        { entity_name = "rocket-silo-vines", offset = { x=0, y=0 } },
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Rocket Silo" }
      }
    })

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  if event.research.name == "rocket-silo" then
    remote.call("k-monuments", "reveal_monument", "rocket-silo")
  end
end)
