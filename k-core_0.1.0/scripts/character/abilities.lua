
Abilities = {
  player = {},
  gear = {},
  gear_lookup = {},
  reserve = {},
  building = {}
}
--player/gear = {
--  name = "use-ability-item-name",
--  gear = nil, -- name of equipment that grants the ability
--  icon = "",
--  energy = { 
--    cost = 1.0, 
--    reserve="reserve-name"
--  },
--  on_trigger = script.generate_event_name(),
--  type = "activate" "target" "area"
--}
--reserve = {
--  name="reserve-name",
--  type="internal" "building" "equipment" "ammo",
--  icon = "",
--  ammo = { ammo_list },
--  recharge=1.0,
--  max=60.0
--}
--building = {
--  name = "entity-name",
--  reserve = "reserve-name",
--  abilities = { ability_list },
--}

-- GLOBALS
-- global.abilities = { 
--  players = { 
--    ["name"] = { 
--      ability_mode=false,
--      abilities = { ["ability-name"] = ref_counter },
--      reserve = { ["reserve-name"] = 0.0 }
--    }
--  },
--  forces = {
--    ["name"] = { 
--      abilities = { ["ability-name"] = ref_counter },
--      reserve = { ["reserve-name"] = { building_list } }
--    }
--  }
--}

-- HELPER FUNCTIONS
local function strip_item_from_main_inventory(player, item)
  local _main_inventory = player.get_inventory(defines.inventory.player_main)
  for i = 1, #_main_inventory do
    if _main_inventory[i].valid_for_read and _main_inventory[i].name == item then
      _main_inventory[i].clear()
    end
  end
end

local function strip_item_from_quickbar(player, item, leave_one)
  local _quickbar = player.get_quickbar()
  local _found = not leave_one
  for i = 1, #_quickbar do
    if _quickbar[i].valid_for_read and _quickbar[i].name == item then
      if _found then
        _quickbar[i].clear()
      else
        _found = true
      end
    end
    -- clear all filters
    if _quickbar.get_filter(i) == item then
      _quickbar.set_filter(i, nil)
    end
  end
  return _found
end

local function for_each_ability( player, fn )
  -- for each ability (player)
  for _name, _ in pairs(global.abilities.players[player.name].abilities) do
    fn(player, Abilities.player[_name] )
  end
  -- for each ability (force)
  for _name, _ in pairs(global.abilities.forces[player.name].abilities) do
    fn(player, Abilities.player[_name] )
  end
  -- for each ability (gear)
  local _inventories = {
      player.get_inventory(defines.inventory.player_guns),
      player.get_inventory(defines.inventory.player_armor),
      player.get_inventory(defines.inventory.player_tools)
    }
  for i = 1, #_inventories do
    local _inventory = _inventories[i]
    for i = 1, #_inventory do
      if _inventory[i].valid_for_read and Abilities.gear_lookup[ _inventory[i].name] then
        -- add ability
        fn(player, Abilities.gear[Abilities.gear_lookup[_inventory[i].name]] )
      end
    end
  end
end

-- GLOBALS FUNCTIONS
local function initalise_globals()
  global.abilities = global.abilities or { players={}, forces={} }
end
local function initalise_force_globals(force)
  initalise_globals();
  global.abilities.forces[force.name] = global.abilities.forces[force.name] or {
    abilities = {},
    reserve = {}
  }
end
local function initalise_player_globals(player)
  initalise_globals();
  global.abilities.players[player.name] = global.abilities.players[player.name] or { 
    ability_mode=false,
    abilities = {},
    reserve = {}
  }
  initalise_force_globals(player.force)
end

-- LIBRARY FUNCTIONS
Abilities.register_ability = function( data )
  setmetatable(data, {__index = Ability})
  if data.gear then
    Abilities.gear[data.name] = data
    for i = 1, #data.gear do
      Abilities.gear_lookup[data.gear[i]] = data.name
    end
  else
    Abilities.player[data.name] = data
  end
end
Abilities.register_reserve = function( data )
  setmetatable(data, {__index = Reserve})
  Abilities.reserve[data.name] = data
end
Abilities.register_building = function( data )
  Abilities.building[data.name] = data
end

Abilities.enter_organise_mode = function( player )
  local function manage_item(player, ability)
    strip_item_from_main_inventory(player, ability.name)
    local _found = strip_item_from_quickbar(player, ability.name, true)
    if not _found then
      -- add to main inventory
      player.insert( {name=ability.name, count=1} )
    end
  end
  
  initalise_player_globals(player)
  for_each_ability( player, manage_item )
  
  global.abilities.players[player.name].ability_mode = false
  player.print("Ability: organise mode")
end
Abilities.enter_ability_mode = function( player )
  local function manage_item(player, ability)
    strip_item_from_main_inventory(player, ability.name)
    
    local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
    for i = 1, #_quickbar do
        if _quickbar[i].valid_for_read and _quickbar[i].name == ability.name then
          -- lock in filters
          _quickbar.set_filter(i, ability.name)
          
          -- remove abilities that are on cooldown
          if not ability:is_available( player ) then
            _quickbar[i].clear()
          end
        end
      end
  end
  
  initalise_player_globals(player)
  for_each_ability( player, manage_item )
  
  global.abilities.players[player.name].ability_mode = true
  player.print("Ability: use mode")
end
-- ABILITY FUNCTIONS
Ability = {}
Ability.add = function(ability, player_or_force)
  if type(player_or_force) == "LuaForce" then
    initalise_force_globals(player_or_force)
    local ref_count = global.abilities.forces[player_or_force.name][ability.name]
    if ref_count == nil then
      global.abilities.forces[player_or_force.name][ability.name] = 1
    else
      global.abilities.forces[player_or_force.name][ability.name] = ref_count + 1
    end
  else
    initalise_player_globals(player_or_force)
    local ref_count = global.abilities.players[player_or_force.name][ability.name]
    if ref_count == nil then
      global.abilities.players[player_or_force.name][ability.name] = 1
    else
      global.abilities.players[player_or_force.name][ability.name] = ref_count + 1
    end
  end
end
Ability.remove = function(ability, player_or_force)
  local strip_item_from_player = function( player, item )
    strip_item_from_main_inventory(player, item)
    strip_item_from_quickbar(player, item)
  end
  
  if type(player_or_force) == "LuaForce" then
    initalise_force_globals(player_or_force)
    local ref_count = global.abilities.forces[player_or_force.name][ability.name]
    if ref_count == 1 then
      global.abilities.forces[player_or_force.name][ability.name] = nil
      for _, _player in pairs(player_or_force.players) do
        strip_item_from_player( _player, ability.name )
      end
    else
      global.abilities.forces[player_or_force.name][ability.name] = ref_count - 1
    end
  else
    initalise_player_globals(player_or_force)
    local ref_count = global.abilities.players[player_or_force.name][ability.name]
    if not ref_count or ref_count == 1 then
      global.abilities.players[player_or_force.name][ability.name] = nil
      strip_item_from_player( player_or_force, ability.name )
    else
      global.abilities.players[player_or_force.name][ability.name] = ref_count - 1
    end
  end
end


Ability.get_energy = function( ability, player )
  initalise_player_globals(player)
  if not ability or not ability.energy or not ability.energy.reserve then
    return 0.0
  end
   
  local _reserve = Abilities.reserve[ ability.energy.reserve ]
  return _reserve:get_energy(player)
end
Ability.add_energy = function( ability, player, energy )
  initalise_player_globals(player)
  if not ability or not ability.energy or not ability.energy.reserve then
    return
  end
  
  local _reserve = Abilities.reserve[ ability.energy.reserve ]
  _reserve:add_energy(player, energy)
end
Ability.remove_energy = function( ability, player, energy )
  initalise_player_globals(player)
  if not ability or not ability.energy or not ability.energy.reserve then
    return
  end
  
  local _reserve = Abilities.reserve[ ability.energy.reserve ]
  _reserve:remove_energy(player, energy)
end
Ability.get_max_energy = function( ability, player )
  initalise_player_globals(player)
  if not ability or not ability.energy or not ability.energy.reserve then
    return 0.0
  end
  
  local _reserve = Abilities.reserve[ ability.energy.reserve ]
  return _reserve:get_max_energy(player)
end

Ability.is_available = function( ability, player )
  local _energy = ability:get_energy( player )
  local _cost = ability.energy.cost
  return _cost <= _energy
end

Ability.activate = function( player, ability, target )
  initalise_globals(player)
  
  if not global.abilities.players[player.name].ability_mode then
      return
  end
  if not ability:is_available( player ) then
    return
  end
  
  if ability and ability.on_trigger then
    game.raise_event( ability.on_trigger, {
        player = player,
        ability = ability,
        target = target
      })
  end
  -- spend energy
  player.clean_cursor()
  ability:remove_energy( player, ability.energy.cost )
  
  -- remove items
  if not ability:is_available( player ) then
    local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
    for i = 1, #_quickbar do
      if _quickbar[i].valid_for_read and _quickbar[i].name == ability.name then
        _quickbar[i].clear()
      end
    end
  end
end
Ability.make_available = function( ability, player )
  -- make sure relevent item is in the filter slot
  local _quickbar = player.get_inventory(defines.inventory.player_quickbar)
  for i = 1, #_quickbar do
    if _quickbar.get_filter(i) == ability.name and not _quickbar[i].valid_for_read then
      _quickbar.insert( {name=ability.name, count=1} )
    end
  end
end

  -- RESERVE FUNCTIONS
Reserve = {}

Reserve.get_energy = function( reserve, player )
  initalise_player_globals(player)
  local _energy = 0.0
  
  -- check energy reserve
  if reserve.type == "building" then
    local _buildings = global.abilities.forces[ player.force.name ].reserve[reserve.name]
    for _, _entity in pairs(_buildings) do
      _energy = _energy + _entity.energy
    end
  elseif reserve.type == "equipment" then
    local _armour = player.get_inventory(defines.inventory.player_armor)[1]
    if _armour and _armour.grid then
      for i = 1, #_armour.grid.equipment do
        if _armour.grid.equipment[i].name == reserve.name then
          _energy = _energy + _armour.grid.equipment[i].energy
        end
      end
    end
  elseif reserve.type == "ammo" then
    local _ammo_inventory = player.get_inventory(defines.inventory.player_ammo)
    for i = 1, #_ammo_inventory do
      if _ammo_inventory[i].valid_for_read and reserve.ammo[_ammo_inventory[i].name] then
        _energy = _energy + ((_ammo_inventory[i].count - 1) * _ammo_inventory[i].prototype.magazine_size) 
                          + _ammo_inventory[i].ammo
      end
    end
  else -- internal
    if not global.abilities.players[ player.name ].reserve[reserve.name] then
      global.abilities.players[ player.name ].reserve[reserve.name] = reserve.max
    end
    _energy = global.abilities.players[ player.name ].reserve[ reserve.name ]
  end
  
  return _energy
end

Reserve.add_energy = function( reserve, player, energy )
  initalise_player_globals(player)
  local _energy = 0.0
  
  -- check energy reserve
  if reserve.type == "building" then
    local _buildings = global.abilities.forces[ player.force.name ].reserve[reserve.name]
    local _energy_per = energy / #_buildings
    for _, _entity in pairs(_buildings) do
      _entity.energy = _entity.energy + _energy_per
    end
  elseif reserve.type == "equipment" then
    local _armour = player.get_inventory(defines.inventory.player_armor)[1]
    if _armour and _armour.grid then
      local _count = 0
      for i = 1, #_armour.grid.equipment do
        if _armour.grid.equipment[i].name == reserve.name then
          _count = _count + 1
        end
      end
      if _count > 0 then
        local _energy_per = energy / _count
        for i = 1, #_armour.grid.equipment do
          if _armour.grid.equipment[i].name == reserve.name then
            _armour.grid.equipment[i].energy = _armour.grid.equipment[i].energy + _energy_per
          end
        end
      end
    end
  elseif reserve.type == "ammo" then
    local _ammo_inventory = player.get_inventory(defines.inventory.player_ammo)
    -- add ammo/magazines
    for i = 1, #_ammo_inventory do
      if _ammo_inventory[i].valid_for_read and reserve.ammo[_ammo_inventory[i].name] then
        -- top up clip
        local _clips = math.floot(_delta / _ammo_inventory[i].prototype.magazine_size)
        local _bullets = energy % _ammo_inventory[i].prototype.magazine_size
        _ammo_inventory[i].count = _ammo_inventory[i].count + _clips
        if _ammo_inventory[i].ammo + _bullets > _ammo_inventory[i].prototype.magazine_size then
          _ammo_inventory[i].count = _ammo_inventory[i].count + 1
          _ammo_inventory[i].ammo = _ammo_inventory[i].ammo + _bullets - _ammo_inventory[i].prototype.magazine_size
        else
          _ammo_inventory[i].ammo = _ammo_inventory[i].ammo + _bullets
        end
      end
    end
  else -- internal
    local _current = global.abilities.players[player.name].reserve[reserve.name]
    local _max = reserve.max
    global.abilities.players[player.name].reserve[reserve.name] = math.min(_current + energy, _max)
  end
end
Reserve.remove_energy = function( reserve, player, energy )
  initalise_player_globals(player)
  local _energy = 0.0
  
  -- check energy reserve
  if reserve.type == "building" then
    local _buildings = global.abilities.forces[ player.force.name ].reserve[reserve.name]
    local _energy_per = energy / #_buildings
    for _, _entity in pairs(_buildings) do
      _entity.energy = math.max( _entity.energy - _energy_per, 0.0 )
    end
  elseif reserve.type == "equipment" then
    local _armour = player.get_inventory(defines.inventory.player_armor)[1]
    if _armour and _armour.grid then
      local _count = 0
      for i = 1, #_armour.grid.equipment do
        if _armour.grid.equipment[i].name == reserve.name then
          _count = _count + 1
        end
      end
      if _count > 0 then
        local _energy_per = energy / _count
        for i = 1, #_armour.grid.equipment do
          if _armour.grid.equipment[i].name == reserve.name then
            _armour.grid.equipment[i].energy = math.max( _armour.grid.equipment[i].energy - _energy_per, 0.0 )
          end
        end
      end
    end
  elseif reserve.type == "ammo" then
    local _ammo_inventory = player.get_inventory(defines.inventory.player_ammo)
    -- remove ammo/magazines
    for i = 1, #_ammo_inventory do
      if _ammo_inventory[i].valid_for_read and reserve.ammo[_ammo_inventory[i].name] then
        local _clips = math.floot(energy / _ammo_inventory[i].prototype.magazine_size)
        local _bullets = energy % _ammo_inventory[i].prototype.magazine_size
        _ammo_inventory[i].count = _ammo_inventory[i].count - _clips
        if _ammo_inventory[i].ammo - _bullets < 0 then
          _ammo_inventory[i].count = _ammo_inventory[i].count - 1
          _ammo_inventory[i].ammo = _ammo_inventory[i].ammo - _bullets + _ammo_inventory[i].prototype.magazine_size
        else
          _ammo_inventory[i].ammo = _ammo_inventory[i].ammo - _bullets
        end
      end
    end
  else -- internal
    local _current = global.abilities.players[ player.name ].reserve[ reserve.name ]
    global.abilities.players[ player.name ].reserve[ reserve.name ] = math.max(_current - energy, 0.0)
  end
end

Reserve.get_max_energy = function( reserve, player )
  initalise_player_globals(player)
  local _energy = 0.0
  
  -- check energy reserve
  if reserve.type == "building" then
    local _buildings = global.abilities.forces[ player.force.name ].reserve[reserve.name]
    for _, _entity in pairs(_buildings) do
      _energy = _energy + _entity.electric_buffer_size 
    end
  elseif reserve.type == "equipment" then
    local _armour = player.get_inventory(defines.inventory.player_armor)[1]
    if _armour and _armour.grid then
      for i = 1, #_armour.grid.equipment do
        if _armour.grid.equipment[i].name == reserve.name then
          _energy = _energy + _armour.grid.equipment[i].max_energy
        end
      end
    end    
  elseif reserve.type == "ammo" then
    local _ammo_inventory = player.get_inventory(defines.inventory.player_ammo)
    for i = 1, #_ammo_inventory do
      if _ammo_inventory[i].valid_for_read and reserve.ammo[_ammo_inventory[i].name] then
        _energy = _energy + (_ammo_inventory[i].stack_size * _ammo_inventory[i].prototype.magazine_size)
      end
    end
  else -- internal
    _energy = reserve.max
  end
  
  return _energy
end


-- EVENTS
Event.register( defines.events.on_player_cursor_stack_changed, function(event)
  -- activate abilities
  local _player = game.players[game.players[event.player_index].name]
  if (not _player.cursor_stack) or (not _player.cursor_stack.valid_for_read) then
    return
  end
  local _ability = Abilities.force[_player.cursor_stack.name]
  if _ability and (not _ability.type or _ability.type == "activate") then
    _ability:activate( _player )
  end
end)

Event.register( defines.events.on_built_entity, function(event)
	local _player = game.players[event.player_index]
  local _ability = event.created_entity.valid and Abilities.player[event.created_entity.name]
  if _ability and (not _ability.type or _ability.type == "target") then
    local _destination = event.created_entity.position
    _player.insert({name = event.created_entity.name, count = 1})
    event.created_entity.destroy()
    _ability:activate( _player, _destination )
  end
end)

Event.register( defines.events.on_player_selected_area, function(event)
  -- area abilities

end)

Event.register( defines.events.on_tick, function(event)
  if not global.abilities then return end

  for _, _player in pairs(game.players) do
    -- update cooldown GUI
    if not _player.gui.left["ability-cooldowns"] then
      _player.gui.left.add { name="ability-cooldowns", type="flow", direction ="vertical" }
    end
    local _gui_frame = _player.gui.left["ability-cooldowns"]
    for _name, _ in pairs(global.abilities.players[_player.name].reserve) do
      local _reserve = Abilities.reserve[_name]
      local _energy = _reserve:get_energy(_player)
      local _energy_max = _reserve:get_max_energy(_player)
      
      -- update internal reserves
      if _reserve.recharge then
        _reserve:add_energy(_player, _reserve.recharge)
        _energy = _reserve:get_energy(_player)
      end
      
      -- update cooldowns
      local _flowname = _name.."-frame"
      if not _gui_frame[_flowname] then
        _gui_frame.add { name=_flowname, type="flow", direction ="horizontal" }
        _gui_frame[_flowname].add { name=_name.."-icon", type="sprite", sprite="item/".._name }
        _gui_frame[_flowname].add { name=_name.."-cooldown", type="progressbar", size = 32, value = _energy / _energy_max }
      else
        _gui_frame[_flowname][_name.."-cooldown"].value = _energy / _energy_max
      end
    end
  end
end)

Event.register({
      defines.events.on_built_entity,
      defines.events.on_robot_built_entity,
      defines.events.on_trigger_created_entity
    }, function(event)
  local _data = Abilities.building[event.created_entity.name]
  if _data then
    if _data.reserve then
      global.abilities.forces[event.created_entity.force.name].reserve[_data.reserve][event.created_entity.unit_number] = event.created_entity
    end
    if _data.abilities then
      for _, _name in pairs(_data.abilities) do
        Abilities.player[_name]:add( event.created_entity.force )
      end
    end
  end
end)
Event.register({
      defines.events.on_preplayer_mined_item,
      defines.events.on_robot_pre_mined,
      defines.events.on_entity_died,
    }, function(event)
  local _data = Abilities.building[event.entity.name]
  if _data then
    if _data.reserve then
      global.abilities.forces[event.entity.force.name].reserve[_data.reserve][event.entity.unit_number] = nil
    end
    if _data.abilities then
      for _, _name in pairs(_data.abilities) do
        Abilities.player[_name]:remove( event.entity.force )
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
