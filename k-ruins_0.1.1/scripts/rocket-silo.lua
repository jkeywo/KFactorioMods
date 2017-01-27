
-- register data

local _static_data = {
    name = "rocket-silo",
    entity_name = "rocket-silo-vines",
    position = {
      offset = { 500, 700 },
    }
  }
local _upgrade_data = {
    name = "rocket-silo-vines",
    upgrades = {
      ["restored-silo"] = {
        entity_name = "rocket-silo"
      }
    }
  }
local _composite_data = {
      base_entity = "rocket-silo-vines",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Rocket Silo" }
      }
    }
  
remote.call( "k-static-entities", "register", _static_data )
remote.call( "k-upgradable-entities", "register", _upgrade_data )
remote.call( "k-composite-entities", "register", _composite_data )

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  if event.research.name == "rocket-silo" then
    remote.call("k-static-entities", "reveal", "rocket-silo")
  end
end)
