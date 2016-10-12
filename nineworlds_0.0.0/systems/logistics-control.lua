local logistics = {}

-- belt GUI
function build_belt_gui(player, entity)
  if not player.gui.left["nw-logistics"] then
    -- show available worlds
    -- -- selected
    -- -- next
    -- -- blocked
    -- -- locked
    -- toggle world hotkey
    -- change send/receive hotkey
  end
end

-- accumulator/storage tank GUI
-- -- show which worlds it connects
function build_storage_tank_gui(player, entity)
  if not player.gui.left["nw-logistics"] then
    -- show connected worlds
    -- -- linked
    -- -- blocked
    -- -- locked
  end
end
function build_accumulator_gui(player, entity)
  if not player.gui.left["nw-logistics"] then
    -- show connected worlds
    -- -- linked
    -- -- blocked
    -- -- locked
  end
end

Event.register(defines.events.on_player_rotated_entity, function(event)
    if entity.name == "nw-belt-send" or entity.name == "nw-belt-receive" then
      Linked.for_each_linked( entity, function(entity)
        -- rotate
      end)
    end
end)

Event.register(defines.events.on_tick, function(event)
  for _, player in pairs(game.players) do
    local entity = player.selected
    if not entity then
      if player.gui.left["nw-logistics"] then player.gui.left["nw-logistics"].destroy() end
    elseif entity.name == "nw-belt-send" then
      build_belt_gui(player, entity)
    elseif entity.name == "nw-belt-receive" then
      build_belt_gui(player, entity)
    elseif entity.name == "nw-storage-tank" then
      build_storage_tank_gui(player, entity)
    elseif entity.name == "nw-accumulator" then
      build_accumulator_gui(player, entity)
    else
      if player.gui.left["nw-logistics"] then player.gui.left["nw-logistics"].destroy() end
    end
  end
end)

Event.register(defines.events.on_built_entity, function(event)
  local entity = event.created_entity
  local _player = game.players[event.player_index]
  local _player_surface = _player.surface

	if entity.name == "nw-belt-send" then
    local _target_surface = Worlds[_player_surface.name].links and Worlds[_player_surface.name].links.down
    if not _target_surface then
      _target_surface = Worlds[_player_surface.name].links and Worlds[_player_surface.name].links.up
    end
    if _target_surface then
      local paired_entity = Linked.create_and_pair( entity, "nw-belt-receive", _player_surface )
      Scheduler.add_to_scheduler( logistics.process_belt, { from = entity, to = paired_entity, belt_speed = 1 } )
    end
  elseif entity.name == "nw-storage-tank" then
    local paired_entity = Linked.create_and_link( entity, "nw-storage-tank", Tunnels.access_worlds )
    Scheduler.add_to_scheduler( logistics.process_liquid, { from = entity, to = paired_entity, belt_speed = 1 } )
  elseif entity.name == "nw-accumulator" then
    local paired_entity = Linked.create_and_link( entity, "nw-accumulator", Tunnels.access_worlds )
    Scheduler.add_to_scheduler( logistics.process_energy, { from = entity, to = paired_entity, belt_speed = 1 } )
	end
end)

Event.register( { 
      defines.events.on_preplayer_mined_item, 
      defines.events.on_preplayer_mined_item,
      defines.events.on_entity_died
    }, function(event)
  local entity = event.entity
  if entity.name == "nw-belt-send" then
    Linked.on_destroyed(entity)
  elseif entity.name == "nw-belt-receive" then
    Linked.on_destroyed(entity)
  elseif entity.name == "nw-storage-tank" then
    Linked.on_destroyed(entity)
  elseif entity.name == "nw-accumulator" then
    Linked.on_destroyed(entity)
	end
end)

-- placeholder code copied from Factorissimo
logistics.process_belt = function(data)
  if data.from.valid and data.to.valid then
    for _i = 1, 2 do
      local _f = data.from.get_transport_line(_i)
      local _t = data.to.get_transport_line(_i)
      for t, c in pairs(_f.get_contents()) do
        if _t.insert_at(0.75, {name = t, count = 1}) then
          _f.remove_item{name = t, count = 1}
        end
      end
    end
    return (9/32)/data.belt_speed
  else
    return false
  end
end

logistics.process_liquid = function(data)
  if data.from.valid and data.to.valid then
    local _fluid_a = data.from.fluidbox[1]
    local _fluid_b = data.to.fluidbox[1]
    
    if _fluid_a or _fluid_b then
      local _new_fluid = nil
      if not _fluid_a then
        -- a does not exist, create and put 1/2 of b in it
        _new_fluid = _fluid_b
        _new_fluid.amount = _fluid_b.amount/2
      elseif not _fluid_b then
        -- b does not exist, create and put 1/2 of a in it
        _new_fluid = _fluid_a
        _new_fluid.amount = _fluid_a.amount/2
      elseif _fluid_a.type == _fluid_b.type then
        -- balance a and b
        _new_fluid = _fluid_a
        _new_fluid.amount = (_fluid_a.amount + _fluid_b.amount)/2
      end
      data.from.fluidbox[1] = _new_fluid
      data.to.fluidbox[1] = _new_fluid
    end
    return 10
  else
    return false
  end
end

logistics.process_energy = function(data)
  if data.from.valid and data.to.valid then
    local _energy_a, _energy_b = data.from.energy, data.to.energy
    local _result = (_energy_a + _energy_b) / 2
    data.to.energy = _result
    data.from.energy = _result
    return 10
  else
    return false
  end
end

return logistics
