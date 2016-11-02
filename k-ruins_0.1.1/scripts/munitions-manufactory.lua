
-- register data
remote.call("k-monuments", "register_monument", {
    name = "munitions-manufactory",
    entity_name = "munitions-manufactory-vines",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 400, 600 },
    },
    upgrades = {
      ["restored-munitions-manufactory"] = {
        entity_name = "munitions-manufactory",
        attract_biters = {
          chance = 0.5,
          cycle = 120 * Time.SECOND,
          count = { 1, 30 },
        }
      }
    }
  })

-- no events

-- reveal on research military 4
Event.register(defines.events.on_research_finished, function(event)
  if event.research.name == "military-4" then
    remote.call("k-monuments", "reveal_monument", "munitions-manufactory")
  end
end)

-- if the monument has created any ammo, try and warp it to the player's inventories
Event.register(defines.events.on_tick, function(event)
  local _entity = remote.call("k-monuments", "get_monument_entity", "munitions-manufactory")
  if _entity and _entity.get_output_inventory() then
    if _entity.valid  then
      local _from = _entity.get_output_inventory().find_item_stack("ancient-rounds-magazine")
      -- find an eligible player
      local _player = game.players[(game.tick % #game.players) + 1]
      if _from and _player then
        local _inventory = _player.get_inventory( defines.inventory.player_ammo )
        local _to = _inventory.find_item_stack("ancient-rounds-magazine")
        if _from and _to and _to.count < 100 then
          _from.count = _from.count - 1
          _to.count = _to.count + 1
        end
      end
    end
  end
end)
