local function try_replace( recipe, from, ... )
  for i, to in ipairs({...}) do
    if data.raw.item[to.name or to] or data.raw.fluid[to.name or to] or data.raw.module[to.name or to] then
       bobmods.lib.replace_recipe_item(recipe, from, to)
       return true
    end
  end
  return false
end

local function try_add( recipe, ... )
  for i, to in ipairs({...}) do
    if data.raw.item[to.name or to] or data.raw.fluid[to.name or to] or data.raw.module[to.name or to] then
      bobmods.lib.recipe.add_ingredient(recipe, to)
      return true
    end
  end
  return false
end

-- rocket-silo
try_replace( "rocket-silo", "pipe", "tungsten-pipe" )
try_replace( "rocket-silo", "processing-unit", "advanced-processing-unit" )

-- satellite
try_replace( "satellite", "radar", "radar-5" )
try_replace( "satellite", "solar-panel", "solar-panel-large-3" )
try_replace( "satellite", "accumulator", "fast-accumulator-3" )
try_replace( "satellite", "processing-unit", "advanced-processing-unit" )

-- low-density-structure
try_replace( "low-density-structure", "steel-plate", "nitinol-alloy" )
try_replace( "low-density-structure", "copper-plate", "aluminium-plate" )

-- rocket-fuel
data.raw.recipe["rocket-fuel"].category = "chemistry"
if not try_add( "rocket-fuel", {type="fluid", name="nitroglycerin", amount=3} ) then
  try_add( "rocket-fuel", {type="fluid", name="sulfuric-acid", amount=10} )
  try_add( "rocket-fuel", {type="fluid", name="nitric-acid", amount=10} )
end

-- rocket-control-unit
try_replace( "rocket-control-unit", "processing-unit", "advanced-processing-unit" )
try_replace( "rocket-control-unit", "speed-module", "god-module-5", "raw-speed-module-8", "speed-module-8" )

-- rocket-engine
try_replace( "rocket-engine", "steel-plate", "cobalt-steel-alloy")
try_replace( "rocket-engine", "iron-plate", "invar-alloy")
try_replace( "rocket-engine", "copper-plate", "tungsten-plate")

-- rocket-part
try_add( "rocket-part", {type="item", name="rocket-engine", amount=10} )
    
-- assembly-robot
try_replace( "assembly-robot", "construction-robot", "bob-construction-robot-4" )
try_replace( "assembly-robot", "speed-module-3", "god-module-5", "raw-speed-module-8", "speed-module-8" )
try_replace( "assembly-robot", "effectivity-module-3", "god-module-5", "green-module-8", "effectivity-module-8" )
    
-- drydock-assembly
try_replace( "drydock-assembly", "processing-unit", "advanced-processing-unit" )
try_replace( "drydock-assembly", "solar-panel", "solar-panel-large-3" )

-- drydock-structural

-- fusion-reactor
try_replace( "fusion-reactor", "fusion-reactor-equipment", "fusion-reactor-equipment-4" )

-- hull-component
try_replace( "hull-component", "steel-plate", "cobalt-steel-alloy" )
  
-- protection-field
try_replace( "protection-field", "energy-shield-mk2-equipment", "energy-shield-mk6-equipment" )
    
-- space-thruster
try_replace( "space-thruster", "speed-module-3", "god-module-5", "raw-speed-module-8", "speed-module-8" )
try_replace( "space-thruster", "pipe", "tungsten-pipe" )
try_replace( "space-thruster", "processing-unit", "advanced-processing-unit" )

-- fuel-cell
try_replace( "fuel-cell", "steel-plate", "invar-alloy" )
try_replace( "fuel-cell", "processing-unit", "advanced-processing-unit" )

-- habitation
try_replace( "habitation", "steel-plate", "tungsten-plate" )
try_replace( "habitation", "processing-unit", "advanced-processing-unit" )

-- life-support
try_replace( "life-support", "productivity-module-3", "god-module-5", "raw-productivity-module-8", "productivity-module-8" )
try_replace( "life-support", "pipe", "tungsten-pipe" )
try_replace( "life-support", "processing-unit", "advanced-processing-unit" )

-- command
try_replace( "command", "speed-module-3", "god-module-5", "raw-speed-module-8", "speed-module-8" )
try_replace( "command", "effectivity-module-3", "god-module-5", "green-module-8", "effectivity-module-8" )
try_replace( "command", "productivity-module-3", "god-module-5", "raw-productivity-module-8", "productivity-module-8" )
try_replace( "command", "processing-unit", "advanced-processing-unit" )
    
-- astrometrics
try_replace( "astrometrics", "speed-module-3", "god-module-5", "raw-speed-module-8", "speed-module-8" )
try_replace( "astrometrics", "processing-unit", "advanced-processing-unit" )

-- ftl-drive
try_replace( "ftl-drive", "speed-module-3", "god-module-5", "raw-speed-module-8", "speed-module-8" )
try_replace( "ftl-drive", "effectivity-module-3", "god-module-5", "green-module-8", "effectivity-module-8" )
try_replace( "ftl-drive", "productivity-module-3", "god-module-5", "raw-productivity-module-8", "productivity-module-8" )
try_replace( "ftl-drive", "processing-unit", "advanced-processing-unit" )
