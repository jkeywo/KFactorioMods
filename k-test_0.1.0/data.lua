
require("config")

-- Composite Entity
local _composite_entity = table.deepcopy( data.raw["ammo-turret"]["gun-turret"] )
_composite_entity.name = "composite-entity"
local _composite_item = table.deepcopy( data.raw.item["gun-turret"] )
_composite_item.name = "composite-entity"
_composite_item.place_result = "composite-entity"
local _composite_recipe = table.deepcopy( data.raw.recipe["gun-turret"] )
_composite_recipe.name = "composite-entity"
_composite_recipe.result = "composite-entity"
_composite_recipe.enabled = true

-- Static Entity
local _static_item = table.deepcopy( data.raw.item["gun-turret"] )
_static_item.name = "static-entity"
_static_item.place_result = "static-entity"
local _static_entity = table.deepcopy( data.raw["ammo-turret"]["gun-turret"] )
_static_entity.name = "static-entity"
-- Upgradable Entity
local _upgradable_item_1_2  = table.deepcopy( data.raw.item["iron-gear-wheel"] )
_upgradable_item_1_2.name = "upgrade-entity-1-2"
local _upgradable_recipe_1_2 = table.deepcopy( data.raw.recipe["iron-gear-wheel"] )
_upgradable_recipe_1_2.name = "upgrade-entity-1-2"
_upgradable_recipe_1_2.result = "upgrade-entity-1-2"
_upgradable_recipe_1_2.enabled = true
local _upgradable_item_1_3  = table.deepcopy( data.raw.item["iron-gear-wheel"] )
_upgradable_item_1_3.name = "upgrade-entity-1-3"
local _upgradable_recipe_1_3 = table.deepcopy( data.raw.recipe["iron-gear-wheel"] )
_upgradable_recipe_1_3.name = "upgrade-entity-1-3"
_upgradable_recipe_1_3.result = "upgrade-entity-1-3"
_upgradable_recipe_1_3.enabled = true

-- Biter Attractor Entity
local _biter_entity = table.deepcopy( data.raw["ammo-turret"]["gun-turret"] )
_biter_entity.name = "biter-entity"
local _biter_item = table.deepcopy( data.raw.item["gun-turret"] )
_biter_item.name = "biter-entity"
_biter_item.place_result = "biter-entity"
local _biter_recipe = table.deepcopy( data.raw.recipe["gun-turret"] )
_biter_recipe.name = "biter-entity"
_biter_recipe.result = "biter-entity"
_biter_recipe.enabled = true

data:extend({
    _composite_entity, _composite_item, _composite_recipe,
    _static_entity, _static_item,
    _upgradable_item_1_2, _upgradable_recipe_1_2,
    _upgradable_item_1_3, _upgradable_recipe_1_3,
    _biter_entity, _biter_item, _biter_recipe,
  })

-- Abilities
require("shared")

-- teleport (click to move)
register_ability( abilities[1] )
-- bubble (toggle to drain energy from buildings)
register_ability( abilities[2] )

data:extend({
  {
    type="sprite",
    name="reserve-internal",
    filename = "__core__/graphics/rename-small.png",
    priority = "extra-high-no-scale",
    width = 16,
    height = 16,
  }
})




