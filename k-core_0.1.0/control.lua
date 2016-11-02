
require("config")

if Config["composite-entities"] then
  require("composite-entities.control")
end
if Config["missions"] then
  require("missions.control")
end
if Config["monuments"] then
  require("monuments.control")
end
if Config["units"] then
  require("units.control")
end
if Config["worlds"] then
  require("worlds.control")
end
