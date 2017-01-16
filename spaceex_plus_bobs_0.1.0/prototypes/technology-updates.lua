bobmods.lib.add_technology_recipe("rocket-silo", "rocket-engine")

if data.raw["tool"]["science-pack-4"] then
	data.raw["technology"]["space-assembly"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["space-construction"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["protection-fields"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["fusion-reactor"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["space-thrusters"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["fuel-cells"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["habitation"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["life-support-systems"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["spaceship-command"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["spaceship-command"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["astrometrics"].unit.ingredients[4] = {"science-pack-4", 1}
	data.raw["technology"]["ftl-propulsion"].unit.ingredients[4] = {"science-pack-4", 1}
end
