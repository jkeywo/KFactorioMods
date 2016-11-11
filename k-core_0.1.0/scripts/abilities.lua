
Abilities = { data = {} }
--{
--  name="",
--  sprite="",
--  tooltip="",
--  cooldown=ticks,
--  on_trigger=script.generate_event_name(),
--  type="activate" "target" "toggle"
--}

Abilities.register_ability = function( data )
  Abilities.data[data.name] = data
end

Abilities.add_ability = function( player, name )
  global.abilities = global.abilities or {}
  global.abilities[player.index] = global.abilities[player.index] or {}
  
  table.insert( global.abilities[player.index], name )

  Abilities.refresh_gui(player)
end

Abilities.remove_ability = function( player, name )
  global.abilities = global.abilities or {}
  global.abilities[player.index] = global.abilities[player.index] or {}

  table.remove( global.abilities[player.index], name )
  
  Abilities.refresh_gui(player)
end

Abilities.refresh_gui = function( player )
  local _ability_list = global.abilities[player.index]
  
  if player.gui.top.ability_list then
    player.gui.top.ability_list.destroy()
  end
  if not _ability_list or #_ability_list == 0 then
    return
  end
  
  player.gui.top.add { name="ability_list", type="frame", direction="horizontal" }
  for _, _name in _ability_list do
    player.gui.top.ability_list.add { name=_name, type="sprite-button",
                                      sprite=Abilities.data[_name].sprite,
                                      tooltip=Abilities.data[_name].tooltip }
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

Abilities.on_pressed = function( player, name )
  local _data = Abilities.data[name]
  if not _data then return end
  
  if not _data.type or _data.type == "activate" then
    Abilities.activate( player, _data )
  elseif _data.type == "target" then
    -- put targeter into player hand
    player.
  elseif _data.type == "area" then
    -- put targeter-area into player hand
  elseif _data.type == "toggle" then
  
  end
end

Event.register( defines.events.on_gui_click, function(event)
  if parent.name ~= "ability_list" then
    return
  end
  if Abilities.data[event.element.name] then
    Abilities.on_pressed( game.players[event.player_index], event.element.name )
  end
end)

Event.register( defines.events.on_gui_checked_state_changed, function(event)
  if parent.name ~= "ability_list" then
    return
  end

end)

