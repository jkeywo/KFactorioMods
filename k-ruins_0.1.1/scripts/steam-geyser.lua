
-- register data
local _static_data = {
    name = "steam-geyser",
    entity_name = "steam-geyser-bare",
    default_floor = "sand",
    position = {
      offset = { 300, 400 },
    }
  }
local _upgrade_data = {
    name = "steam-geyser-bare",
    upgrades = {
      ["restored-steam-geyser"] = {
        entity_name = "steam-geyser-pump",
      }
    }
  }
local _event_data = {
    entity_name = "steam-geyser-pump",
    on_tick = script.generate_event_name(),
    attract_biters = {
      chance = { 0.0, 0.5 },
      cycle = 600 * Time.SECOND,
      count = { 1, 10 },
    }
  }
local _composite_data = {
      base_entity = "steam-geyser-bare",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Steam Geyser" }
      }
    }

remote.call( "k-static-entities", "register", _static_data )
remote.call( "k-upgradable-entities", "register", _upgrade_data )
remote.call( "k-entity-events", "register", _event_data )
remote.call( "k-composite-entities", "register", _composite_data )

-- if the pump has created any water, make it 100 degrees
Event.register(_event_data.on_tick, function(event)
  if event.entity and event.entity.valid and event.entity.fluidbox then
    for i = 1, #event.entity.fluidbox do
      if event.entity.fluidbox[i] and event.entity.fluidbox[i].temperature then
        local _box = event.entity.fluidbox[i]
        _box.temperature = 100
        event.entity.fluidbox[i] = _box
      end
    end
  end
end)