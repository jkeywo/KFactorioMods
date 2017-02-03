
Buffs = {
  data = {}
}
-- data = {
--  name = "",
--  sprite = ""
--  energy = { reserve = "ability_reserve" or 600, drain = 1.0 / 60.0 }
--  charges = { 1, 600 },
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
  if player then
    global.buffs.players[player.name] = global.buffs.players[player.name] or { player = player }
  end
end

Buffs.register = function( buff )
  setmetatable(buff, {__index = Buffs})
  Buffs.data[buff.name] = buff
end

Buffs.rank = function( buff, player )
  initialise_globals(player)
  local _buff_data = global.buffs.players[player.name][buff.name]
  if not _buff_data then return 0 end
  if not buff.charges then return 1 end
  
  local _charge = _buff_data.charge
  if not _charge and _buff_data.reserve then
    Abilities.reserve[buff.energy.reserve]:get_energy( player )
  end
  
  local _rank = 0
  for i = 1, #buff.charges - 1 do
    if _charge > buff.charges[i] then
      _rank = _rank + 1
    end
  end
  return _rank
end

Buffs.apply = function( buff, player, charge )
  initialise_globals(player)
  local _player_data = global.buffs.players[player.name]
  if _player_data[buff.name] then
    -- add charge
    if charge or type(buff.energy.reserve) == "number" then
      charge = charge or buff.energy.reserve
      _player_data[buff.name].charge = math.min( _player_data[buff.name].charge + charge, buff.charges[#buff.charges] )
    end
  else
    if charge or type(buff.energy.reserve) == "number" then
      _player_data[buff.name] = { active = true, charge = charge or buff.energy.reserve }
    else
      _player_data[buff.name] = { active = true }
    end
  end
  -- on_enter event
  if buff.on_start then
    game.raise_event( buff.on_start, {
      player = player,
      buff = buff,
    })
  end
end

Buffs.remove = function( buff, player, charge )
  initialise_globals(player)
  local _player_data = global.buffs.players[player.name]
  if _player_data[buff.name] then
    if charge and _player_data[buff.name].charge then
      _player_data[buff.name].charge = _player_data[buff.name].charge - charge
    else
      _player_data[buff.name] = { active = false }
    end
  end
end

Buffs.get = function( buff, player )
  initialise_globals(player)
  return global.buffs.players[player.name][buff.name]
end

Event.register( defines.events.on_tick, function(event)
  -- update buffs
  initialise_globals()
  for _, _player_data in pairs(global.buffs.players) do
    local _player = _player_data.player
    
    if not _player.gui.top["buff-timers"] then
      _player.gui.top.add { name="buff-timers", type="flow", direction ="horizontal" }
    end
    local _gui_frame = _player.gui.top["buff-timers"]
    
    for _buff_name, _buff_data in pairs(_player_data) do
      if _buff_data ~= _player then
        local _buff = Buffs.data[_buff_name]
        local _finished = not _buff_data.active
        
        -- drain energy
        local _energy, _energy_max = nil, nil
        
        if type(_buff.energy.reserve) == "string" then
          -- drain from energy reserve
          local _reserve = Abilities.reserve[_buff.energy.reserve]
          _energy = _reserve:get_energy(_player)
          _energy_max = _reserve:get_max_energy(_player)
          if _energy >= _buff.energy.drain then
            _reserve:remove_energy(_player, _buff.energy.drain)
          else
            _finished = true
          end
        else
          -- drain from internal number
          _energy = _buff_data.charge
          _energy_max = _buff.energy.reserve
          if _energy >= _buff.energy.drain then
            _buff_data.charge = _buff_data.charge - _buff.energy.drain
          else
            _finished = true
          end
        end
        
        local _flowname = _buff_name.."-frame"
        if _finished then
          if _gui_frame[_flowname] then _gui_frame[_flowname].destroy() end
        else
          if not _gui_frame[_flowname] then
            _gui_frame.add { name=_flowname, type="flow", direction ="vertical" }
            _gui_frame[_flowname].add { name=_buff_name.."-icon", type="sprite", sprite=_buff_data.sprite }
            _gui_frame[_flowname].add { name=_buff_name.."-duration", type="progressbar", size = "16", value = _energy /_energy_max }
          else
            _gui_frame[_flowname][_buff_name.."-duration"].value = _energy /_energy_max
          end
        end
        
        -- update or exit
        if _finished then
          if _buff.on_end then
            game.raise_event(_buff.on_end, {
              player = _player,
              buff = _buff,
            })
          end
          _player_data[_buff_name] = nil
        else
          if _buff.on_tick then
            game.raise_event(_buff.on_tick, {
              player = _player,
              buff = _buff,
            })
          end
        end
      end
    end
  end
end)