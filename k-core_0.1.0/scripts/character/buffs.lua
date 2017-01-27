
Buffs = {
  data = {}
}
-- data = {
--  name = "",
--  max_charges = 1,
--  duration = 600,
--  on_start = game.get_event_thingy(),
--  on_tick = game.get_event_thingy(),
--  on_end = game.get_event_thingy()
-- }

-- global.buffs = { 
--    players = { 
--      ["name"] = { 
--        ["buff_name"] = { charges = 1, duration = 600 }
--      }
--    }
--  }

local function initialise_globals(player)
  global.buffs = global.buffs or { players = {} }
  global.buffs.players[player.name] = global.buffs.players[player.name] or { player = player }
end

Buffs.register = function( buff )
  setmetatable(buff, {__index = Buffs})
  Buffs.data[buff.name] = buff
end

Buffs.apply = function( buff, player )
  initialise_globals(player)
  if global.buffs.players[player.name][buff.name] then
    -- add charge
    global.buffs.players[player.name][buff.name].charges = math.min( global.buffs.players[player.name][buff.name].charges + 1, buff.max_charges )
  else
    global.buffs.players[player.name][buff.name] = { charges = 1, duration = buff.duration }
  end
  -- on_enter event
  
end

Event.register( defines.events.on_tick, function(event)
  -- update buffs
  global.buffs = global.buffs or { players = {} }
  for _, _player_data in pairs(global.buffs.players) do
    local _player = _player_data.player
    for _buff_name, _buff_data in pairs(_player_data) do
      local _buff = Buffs.data[_buff_name]
      -- update duration
      
      -- update or exit
      
    end
  end
end)