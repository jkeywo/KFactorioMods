
require("config")
require("shared-data")
require("styles.lua")

data:extend(
{
  {
		type = "item-group",
		name = "monuments",
    icon = "__k-ruins__/graphics/obelisk/obelisk_icon.png",
		order = "z-b",
  },  
  {
		type = "item-subgroup",
		name = "ruins",
		group = "monuments",
		order = "d-b",
 },
  {
		type = "item-subgroup",
		name = "ruins-products",
		group = "monuments",
		order = "b-b",
 },
})

for i = 0, 4 do
  data:extend(
  {
    {
      type="sprite",
      name="war_shrine_rank_"..i,
      filename = "__k-ruins__/graphics/sprites/war_shrine_"..i..".png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 32
    }
  }
end


if Config.obelisks then
  require("prototypes.obelisk")
end
if Config.world_tree then
  require("prototypes.world-tree")
end
if Config.rocket_silo then
  require("prototypes.rocket-silo")
end
if Config.munitions_manufactory then
  require("prototypes.munitions-manufactory")
end
if Config.steam_geyser then
  require("prototypes.steam-geyser")
end
if Config.deep_mine then
  require("prototypes.deep-mine")
end
if Config.war_shrine then
  require("prototypes.war-shrine")
end

