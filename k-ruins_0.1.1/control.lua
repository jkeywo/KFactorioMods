
require("stdlib.area.area")
require("stdlib.event.event")
require("stdlib.time")

require("config")
require("shared-data")

if Config.obelisks then
  require("scripts.obelisk")
end
if Config.world_tree then
  require("scripts.world-tree")
end
if Config.rocket_silo then
  require("scripts.rocket-silo")
end
if Config.munitions_manufactory then
  require("scripts.munitions-manufactory")
end
if Config.steam_geyser then
  require("scripts.steam-geyser")
end
