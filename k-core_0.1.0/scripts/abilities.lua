
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
    if global.abilities.players[player.index] == nil then
      global.abilities.players[player.index][internal_name(name)] = 0
    end
  end
  if type(player_or_force) == "LuaForce" then
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
  for _name, _ability in pairs(global.abilities.players[player.index]) do
    if _name ~= "ability_mode" then
      local _found = false
      for i = 1, #_quickbar do
        if _quickbar[i].valid_for_read and _quickbar[i].name == _name then
          if _found then
            _quickbar[i].clear()
          else
            _found = true
          end
        end
        if not _found then
          -- add to main inventory
          player.insert( {name=_name, count=1} )
        end
        -- clear all filters
        if _quickbar.get_filter(i) == _name then
          _quickbar.set_filter(i, nil)
        end
      end
    end
  end
  global.abilities.players[player.index].ability_mode = false
  player.print("Ability: organise mode")
end

Abilities.enter_ability_mode = function( player )
  initalise_globals(player)
  local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
  local _inventory = player.get_inventory(defines.inventory.player_main)
  for _name, _ability in pairs(global.abilities.players[player.index]) do
     -- clear abilities from the inventory
    for i = 1, #_inventory do
      if _inventory[i].valid_for_read and _inventory[i].name == _name then
        _inventory[i].clear()
      end
    end
    for i = 1, #_quickbar do
      if _quickbar[i].valid_for_read and _quickbar[i].name == _name then
        -- lock in filters
        _quickbar.set_filter(i, _name)
        -- remove abilities that are on cooldown
        if _ability > 0 then
          _quickbar[i].clear()
        end
      end
    end
  end
  global.abilities.players[player.index].ability_mode = true
  player.print("Ability: use mode")
end

Abilities.start_cooldown = function( player, data )
  -- set cooldown
  global.abilities.players[player.index][data.name] = data.cooldown
  
  -- remove items
  local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
  for i = 1, #_quickbar do
    if _quickbar[i].valid_for_read and _quickbar[i].name == data.name then
      _quickbar[i].clear()
    end
  end
  
  -- if no cooldown, call end_cooldown immediately
  if global.abilities.players[player.index][data.name] == 0 then
    Abilities.end_cooldown( player, data )
  end
end

Abilities.end_cooldown = function( player, data )
  local _ability_name = internal_name(data.name)
  -- make sure relevent item is in the filter slot
  local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
  for i = 1, #_quickbar do
    if _quickbar.get_filter(i) == _ability_name and not _quickbar[i].valid_for_read then
      _quickbar.insert( {name=_ability_name, count=1} )
    end
  end
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
      _player.clean_cursor()
    end
  end
end)

Event.register( defines.events.on_built_entity, function(event)
	local _player = game.players[event.player_index]
  local _ability = event.created_entity.valid and Abilities.data[event.created_entity.name]
  if _ability and (not _ability.type or _ability.type == "target") then
    local _destination = event.created_entity.position
    _player.insert({name = event.created_entity.name, count = 1})
    event.created_entity.destroy()
    Abilities.activate( _player, _ability, _destination )
  end
end)

Event.register( defines.events.on_player_selected_area, function(event)
  -- area abilities

end)

Event.register( defines.events.on_tick, function(event)
  for _, _player in pairs(game.players) do
    -- update cooldown GUI
    if not _player.gui.left["ability-cooldowns"] then
      _player.gui.left.add { name="ability-cooldowns", type="flow", direction ="vertical" }
    end
    local _gui_frame = _player.gui.left["ability-cooldowns"]
    for _name, _cooldown in pairs(global.abilities.players[_player.index]) do
      -- update cooldowns
      if type(_cooldown) == "number" and _cooldown > 0 then
        global.abilities.players[player.index][_name] = _cooldown - 1
        if not _gui_frame[_name] then
          _gui_frame.add { name=_name.."-frame", type="flow", direction ="horizontal" }
          _gui_frame[_name.."-frame"].add { name=_name.."-icon", type="sprite", sprite="item/".._name }
          _gui_frame[_name.."-frame"].add { name=_name.."-cooldown", type="label", caption=_cooldown }
        else
          _gui_frame[_name.."-frame"][_name.."-cooldown"].caption=_cooldown
        end
      elseif _gui_frame[_name] then
        _gui_frame[_name].destroy()
      end
    end
  end
end)

script.on_event("toggle-ability-mode", function(event)
  local _player = game.players[event.player_index]
  if global.abilities.players[_player.index].ability_mode then
    Abilities.enter_organise_mode( _player )
  else
    Abilities.enter_ability_mode( _player )
  end
    
end)

-- TEST

Event.register( test_abilities[1].on_trigger, function(event)
    event.player.teleport(event.target)
end)
Event.register( test_abilities[2].on_trigger, function(event)
  for i = 1, 10 do
    event.player.surface.create_entity { name = "destroyer", position = event.player.position, force = event.player.force, target=event.player }
  end
end)

Abilities.register_ability( test_abilities[1] )
Abilities.register_ability( test_abilities[2] )

Event.register( defines.events.on_player_joined_game, function(event)
  Abilities.add_ability( game.players[event.player_index], "test-ability-teleport" )
  Abilities.add_ability( game.players[event.player_index], "test-ability-swarm" )
end)


