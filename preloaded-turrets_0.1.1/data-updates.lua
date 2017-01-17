
require("config")

local _data_to_add = {}
local _tech_to_add = {}

local function add_ammo( ammo_type )
  local _subgroup_data = {
      type = "item-subgroup",
      name = "preloaded-"..ammo_type.name,
      group = "combat",
      order = "f["..ammo_type.name.."]"
    }
  table.insert( _data_to_add, _subgroup_data )
end
local function add_turret( turret, ammo_type, ammo_count )
  local _name = "preloaded-"..turret.name.."-"..ammo_type.name.."-"..ammo_count
  
  local _tech_found = false
  for _, _tech in pairs(data.raw["technology"]) do
    if _tech.effects then
      local _found = false
      for _, _effect in pairs(_tech.effects) do
        if _effect.type == "unlock-recipe" and _effect.recipe == turret.name then
          _tech_found = true
          _found = true
        end
      end
      if _found then
        _tech_to_add[_tech.name] = _tech_to_add[_tech.name] or {}
        table.insert(_tech_to_add[_tech.name], { type = "unlock-recipe", recipe = _name } )
      end
    end
  end
  
  local _item_data = table.deepcopy( data.raw["item"][turret.name] )
  _item_data.name = _name
  _item_data.order = "a["..turret.name.."]-b["..ammo_count.."]"
  _item_data.subgroup = "preloaded-"..ammo_type.name
  _item_data.place_result = _name
  table.insert( _data_to_add, _item_data )

  local _recipe_data = {
      type = "recipe",
      name = _name,
      enabled = not _tech_found,
      ingredients =
      {
        { turret.name, 1 },
        { ammo_type.name, ammo_count }
      },
      result = _name,
    }
  table.insert( _data_to_add, _recipe_data )

  local _turret_data = table.deepcopy(turret)
  _turret_data.name = _name
  table.insert( _data_to_add, _turret_data )
end

for _, _ammo_type in pairs(data.raw["ammo"]) do
  if not Config.ammo_blacklist[_ammo_type.name] then
    add_ammo( _ammo_type )
    for _, _turret in pairs(data.raw["ammo-turret"]) do
      if not Config.turret_blacklist[_turret.name]
          and _ammo_type.ammo_type.category == _turret.attack_parameters.ammo_category then
        for _, _ammo_count in pairs(Config.load_counts) do
          add_turret( _turret, _ammo_type, _ammo_count )
        end
      end
    end
  end
end

data:extend( _data_to_add )
for _name, _list in pairs(_tech_to_add) do
  for _, _data in pairs(_list) do
    table.insert( data.raw["technology"][_name].effects, _data )
  end
end