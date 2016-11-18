
require("stdlib.time")

require("config")
require("shared-data")

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

