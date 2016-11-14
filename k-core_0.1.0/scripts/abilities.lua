
Abilities = { data = {} }
--{
--  name="",
--  icon="",
--  cooldown=ticks,
--  on_trigger=script.generate_event_name(),
--  type="activate" "target" "area"
--}

local function internal_name(name) return "ability-"..name end

local function initalise_globals(player_or_nil)
  global.abilities = global.abilities or { players={} }
  if player_or_nil then
    global.abilities.players[player_or_nil.index] = global.abilities.players[player_or_nil.index] or { ability_mode=false }
  end
end

Abilities.register_ability = function( data )
  Abilities.data[internal_name(data.name)] = data
end

Abilities.add_ability = function( player_or_force, name )
  local add_to_player = function( player, name )
    initalise_globals(player)
    global.abilities.players[player.index][internal_name(name)] = 0
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
    global.abilities.players[player.index][internal_name(name)] = nil
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

Abilities.enter_organise_mode = function( player )
  initalise_globals(player)
  -- for each ability
  local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
  local _inventory = player.get_inventory(defines.inventory.player_main)
  for _name, ability in pairs(global.abilities.players[player.index]) do
    local _found = false
    for i = 1, #_quickbar do
      if _quickbar[i].name == _name then
        if _found then
          _quickbar[i].clear()
        else
          _found = true
        end
      end
      if not _found then
        -- add to main inventory
        _inventory.insert( {_name, 1} )
      end
      -- clear all filters
      if _quickbar.get_filter(i) == _name then
        _quickbar.set_filter(i)
      end
    end
  end
end
Abilities.enter_ability_mode = function( player )
  initalise_globals(player)
  local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
  local _inventory = player.get_inventory(defines.inventory.player_main)
  for _name, _ability in pairs(global.abilities.players[player.index]) do
     -- clear abilities from the inventory
    for i = 1, #_inventory do
      if _inventory[i].name == _name then
        _inventory[i].clear()
      end
    end
    for i = 1, #_quickbar do
      if _quickbar[i].name == _name then
        -- lock in filters
        _quickbar.set_filter(i, _name)
        -- remove abilities that are on cooldown
        if _ability > 0 then
          _quickbar[i].clear()
        end
      end
    end
  end
end

Abilities.start_cooldown = function( player, data )
  -- set cooldown
  -- remove items
  -- if no cooldown, call end_cooldown
  
end

Abilities.end_cooldown = function( player, data )
  -- make sure relevent item is in the filter slot
  
end

Abilities.activate = function( player, data, target )
  initalise_globals(player)
  
  if not global.abilities.players[player.index].ability_mode then
      return
  end
  if not global.abilities.players[player.index]["ability-"..data.name]
    or global.abilities.players[player.index]["ability-"..data.name] > 0 then
    return
  end
  
  if data and data.on_trigger then
    game.raise_event( data.on_trigger, {
        player = player,
        ability = data,
        target = target
      })
  end
  -- put on cooldown
  Abilities.start_cooldown(player, data)
end

Event.register( defines.events.on_player_cursor_stack_changed, function(event)
  -- activate abilities
  local _player = game.players[event.player_index]
  if (not _player.cursor_stack) or (not _player.cursor_stack.valid_for_read) then
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
  local _player = game.players[event.player_index]
  if not _player.cursor_stack or not _player.cursor_stack.valid then
    return
  end
  local _ability = Abilities.data[_player.cursor_stack.name]
  if _ability then
    if not _ability.type or _ability.type == "activate" then
      -- destroy entity
      _position = event.created_entity.position
      event.created_entity.destroy()
      -- activate ability at target point
      Abilities.activate( _player, _ability, _position )
    end
  end
end)

Event.register( defines.events.on_player_selected_area, function(event)
  -- area abilities

end)

Event.register( defines.events.on_tick, function(event)
  -- update cooldowns
  -- update coolodwn GUI
end)
