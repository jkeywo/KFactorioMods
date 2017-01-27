
local _static_data = {
    name = "munitions-manufactory",
    entity_name = "munitions-manufactory-vines",
    position = {
      offset = { 400, 600 },
    }
  }
local _upgrade_data = {
    name = "munitions-manufactory-vines",
    upgrades = {
      ["restored-munitions-manufactory"] = {
        entity_name = "munitions-manufactory",
      }
    }
  }
local _event_data = {
    name = "munitions-manufactory",
    on_tick = script.generate_event_name(),
    attract_biters = {
      chance = 0.5,
      cycle = 120 * Time.SECOND,
      count = { 1, 30 },
    }
  }
local _restored_composite_data = {
    base_entity = "munitions-manufactory-vines",
    destroy_origional = false,
    component_entities = {
      { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Munitions Manufactory" }
    }
  }
  
-- register data
remote.call( "k-static-entities", "register", _static_data )
remote.call( "k-upgradable-entities", "register", _upgrade_data )
remote.call( "k-entity-events", "register", _event_data )
remote.call( "k-composite-entities", "register", _restored_composite_data )
  
-- events
Event.register(defines.events.on_research_finished, function(event)
  -- reveal after researching military 4
  if event.research.name == "military-4" then
    remote.call("k-static-entities", "reveal", "munitions-manufactory")
  end
end)

Event.register(_event_data.on_tick, function(event)
-- if the monument has created any ammo, try and warp it to the player's inventories
  if event.entity and event.entity.get_output_inventory() then
    if event.entity.valid  then
      local _from = event.entity.get_output_inventory().find_item_stack("vanir-rounds-magazine")
      -- find an eligible player
      local _player = game.players[(game.tick % #game.players) + 1]
      if _from and _player then
        local _inventory = _player.get_inventory( defines.inventory.player_ammo )
        local _to = _inventory.find_item_stack("vanir-rounds-magazine")
        if _from and _to and _to.ammo < 10 then
          local _ammo_to_transfer = math.min( 10 - _to.ammo, _from.ammo )
          _from.drain_ammo(_ammo_to_transfer)
          _to.add_ammo(_ammo_to_transfer)
        end
      end
    end
  end
end)
