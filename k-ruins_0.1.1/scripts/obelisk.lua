
local _upgrade_data = {
    name = "obelisk-ruined",
    upgrades = {
      ["restored-obelisk"] = {
        entity_name = "obelisk",
      }
    }
  }
local _event_data = {
    name = "obelisk",
    attract_biters = {
      chance = { 0.0, 0.75 },
      cycle = 300 * Time.SECOND,
      count = { 1, 20 },
    }
  }

local _composite_data = {
    base_entity = "obelisk-ruined",
    destroy_origional = false,
    component_entities = {
      { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Obelisk" }
    }
  }
  
for i = 1, Config.obelisks do
  local _static_data = {
      name = "obelisk-"..i,
      localised_name="obelisk",
      entity_name = "obelisk-ruined",
      position = {
        offset = { 30, 120 },
      }
    }
  remote.call( "k-static-entities", "register", _static_data )
end

remote.call( "k-upgradable-entities", "register", _upgrade_data )
remote.call( "k-entity-events", "register", _event_data )
remote.call( "k-composite-entities", "register", _composite_data )

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-2" then
      for i = 1, Config.obelisks do
        remote.call("k-static-entities", "reveal", "obelisk-"..i)
      end
    end
  end
end)
