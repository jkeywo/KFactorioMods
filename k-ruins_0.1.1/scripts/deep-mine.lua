
local _static_data = {
    name = "deep-mine",
    entity_name = "deep-mine-ruined",
    position = {
      offset = { 50, 80 },
    },
  }
local _upgrade_data = {
    name = "deep-mine-ruined",
    upgrades = {
      ["restored-deep-mine"] = {
        entity_name = "deep-mine",
      }
    }
  }
local _event_data = {
    name = "deep-mine",
    on_tick = script.generate_event_name(),
    attract_biters = {
      chance = 0.5,
      cycle = 90 * Time.SECOND,
      count = { 2, 40 },
    }
  }
local _ruined_composite_data = {
      base_entity = "deep-mine-ruined",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=-1, y=-1 }, operable=false, lable="Ruined Mine" },
      }
    }
local _restored_composite_data = {
      base_entity = "deep-mine",
      destroy_origional = false,
      component_entities = {
        { entity_name = "iron-chest", offset = { x=-2, y=3 }, operable=false },
        { entity_name = "loader", offset = { x=-2, y=1 }, operable=false, type="output" },
        { entity_name = "iron-chest", offset = { x=2, y=3 }, operable=false },
        { entity_name = "loader", offset = { x=2, y=1 }, operable=false, type="output" },
      }
    }

-- register data
remote.call( "k-static-entities", "register", _static_data )
remote.call( "k-upgradable-entities", "register", _upgrade_data )
remote.call( "k-entity-events", "register", _event_data )
remote.call( "k-composite-entities", "register", _ruined_composite_data )
remote.call( "k-composite-entities", "register", _restored_composite_data )

-- events
Event.register( _event_data.on_tick, function(event)
  if event.tick % 60 == 1 then
    -- fill chests
    local _mine_parts = event.entity and remote.call( "k-composite-entities", "get_linked", event.entity ) or nil
    if not _mine_parts then return end
    local index = 0
    for _, _entity in pairs(_mine_parts) do
      if _entity.type == "container" then
        local _inventory = _entity.get_inventory(defines.inventory.chest)
        if index == 0 then
          if _inventory.get_item_count("iron-ore") < 40 then
            _inventory.insert({name="iron-ore", count=40})
          end
        elseif index == 1 then
          if _inventory.get_item_count("copper-ore") < 40 then
            _inventory.insert({name="copper-ore", count=40})
          end
        end
        index = index + 1
      end
    end        
  end
end)
