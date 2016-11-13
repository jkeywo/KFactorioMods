
-- - TODO
-- don't assign a new quick bar
-- instead have a 'move ability' mode and a 'use ability mode' you can toggle between
-- 'move abilities' clears inventory of excess ability items and puts the right number back in place
-- 'use abilities' locks items in place with filters, removes items on cooldown, makes sure there are no changes in position

Abilities = { data = {} }
--{
--  name="",
--  icon="",
--  cooldown=ticks,
--  on_trigger=script.generate_event_name(),
--  type="activate" "target" "area" "toggle"
--}

local function initalise_globals(player_or_force_or_nil)
  global.abilities = global.abilities or { players={}, forces={} }
  if player_or_force_or_nil then
    if player_or_force_or_nil.quickbar_count then
      global.abilities.forces[player_or_force_or_nil.name] = global.abilities.forces[player_or_force_or_nil.name] or {}
    else
      global.abilities.players[player.index] = global.abilities.players[player.index] or {}
      global.abilities.forces[player_or_force_or_nil.force.name] = global.abilities.forces[player_or_force_or_nil.force.name] or {}
    end
  end
end

Abilities.register_ability = function( data )
  Abilities.data["ability-"..data.name] = data
end

Abilities.add_ability = function( player_or_force, name )
  local add_to_player = function( player, name )
    initalise_globals(player)
    global.abilities.players[player.index][name] = 0
    Abilities.refresh_quickbar(player)
  end
  
  if player_or_force.quickbar_count then
    -- is a force
    for _, _player in pairs(player_or_force.players) do
      add_to_player( _player, name )
    end
  else
    -- is (presumably) a player
    add_to_player( player_or_force, name )
  end
end

Abilities.remove_ability = function( player_or_force, name )
  local remove_from_player = function( player, name )
    initalise_globals(player)
    global.abilities.players[player.index][name] = nil
    Abilities.refresh_quickbar(player)
  end
  
  if player_or_force.quickbar_count then
    -- is a force
    for _, _player in pairs(force.players) do
      remove_from_player( _player, name )
    end
  else
    -- is (presumably) a player
    remove_from_player( player_or_force, name )
  end
end

Abilities.refresh_quickbar = function( player )
  initalise_globals( player )
  
  -- add a new quick bar if needed
  if not global.abilities.forces[player.force.name].has_quickbar then
    -- add quick bar to entire force
    global.abilities.forces[player.force.name].has_quickbar = true
    player.force.quickbar_count = player.force.quickbar_count + 1
    for _, _player in pairs(player.force.players) do
      -- put blank filters on the new quickbar
      local _inventory = _player.get_inventory(defines.inventory.player_quickbar)
      for i = 1, 12 do
        _inventory.set_filter( (player.force.quickbar_count * 12) + i, "ability-empty" )
      end
    end
  end
  
  -- filter quick bar
  local _inventory = _player.get_inventory(defines.inventory.player_quickbar)
  
  -- find correct quick bar
  
  local _slot_end = (player.force.quickbar_count * 12)
  local _slot = _slot_end - 11
  for _name, _cooldown in pairs(global.abilities.players[player.index]) do
    _inventory.set_filter( _slot )
    local _stack = _inventory[_slot]
    if _cooldown <= 0 then
      _stack.set_stack({name="ability-".._name, count=1})
    else
      _stack.clear()
    end
    _inventory.set_filter( _slot, "ability-".._name )
    _slot = _slot + 1
  end
  for i = _slot, _slot_end do
    _inventory.set_filter( i, "ability-empty" )
  end
end

Abilities.activate = function( player, data, target )
  if data and data.on_trigger then
    game.raise_event( data.on_trigger, {
        player = player,
        ability = data,
        target = target
      })
  end
end

Event.register( defines.events.on_player_cursor_stack_changed, function(event)
  -- activate/toggle abilities
  local _player = game.players[event.player_index]
  if not _player.cursor_stack or not _player.cursor_stack.valid then
    return
  end
  local _ability = Abilities.data[_player.cursor_stack.name]
  if _ability then
    if not _ability.type or _ability.type == "activate" then
      Abilities.activate( _player, _ability )
      _player.clear_cursor()
    end
  end
end)

Event.register( defines.events.on_built_entity, function(event)
  -- target abilities
  
end)

Event.register( defines.events.on_player_selected_area, function(event)
  -- area abilities

end)

Event.register( defines.events.on_player_quickbar_inventory_changed, function(event)
  -- make sure abilities are only in the correct place
  
end)
