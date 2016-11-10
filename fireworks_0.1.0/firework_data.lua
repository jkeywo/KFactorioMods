
-- TODO - multi coloured
colours = {
  { name = "red",     rgb = {r=1.0, g=0.0, b=0.0} },
  { name = "green",   rgb = {r=0.0, g=1.0, b=0.0} },
  { name = "blue",    rgb = {r=0.0, g=0.0, b=1.0} },
  { name = "yellow",  rgb = {r=1.0, g=1.0, b=0.0} },
  { name = "magenta", rgb = {r=1.0, g=0.0, b=1.0} },
  { name = "cyan",    rgb = {r=0.0, g=1.0, b=1.0} },
  { name = "white",   rgb = {r=1.0, g=1.0, b=1.0} },
}

fireworks = {
  {
    name = "flare",
    cooldown = 30,
    range = 50,
    speed = 1,
    ingredients = { {"grenade", 1} },
    stages =
    {
      { suffix = "", light = {intensity = 0.1, size = 80 }, duration = 60 }
    },
    display = nil
  },
  { 
    name = "firework-large", 
    cooldown = 30, 
    range = 50, 
    speed = 1, 
    ingredients = { {"grenade", 3} },
    stages =
    {
      { suffix = "", light = { intensity = 0.1, size = 4 }, duration = 0.05, fragments = 24, fragment_distance = 12, fragment_speed = 3 },
      { suffix = "-sparks", light = { intensity = 0.1, size = 4 }, duration = 0.05 }
    },
    display = {
      budget = 3
    }
  },
  {
    name = "firework-medium",
    cooldown = 30, 
    range = 50, 
    speed = 1, 
    ingredients = { {"grenade", 2} },
    stages =
    {
      { suffix = "", light = { intensity = 0.1, size = 1 }, duration = 0.05, fragments = 8, fragment_distance = 8, fragment_speed = 2 },
      { suffix = "-sub", light = { intensity = 0.1, size = 1 }, duration = 0.05, fragments = 6, fragment_distance = 4, fragment_speed = 3 },
      { suffix = "-sparks", light = { intensity = 0.1, size = 1 }, duration = 0.05 }
    },
    display = {
      budget = 2
    }
  },
  { 
    name = "firework-small", 
    cooldown = 30, 
    range = 50, 
    speed = 1, 
    ingredients = { {"grenade", 1} },
    stages =
    {
      { suffix = "", light = { intensity = 0.1, size = 2 }, duration = 0.05, fragments = 12, fragment_distance = 8, fragment_speed = 4 },
      { suffix = "-sparks", light = { intensity = 0.1, size = 2 }, duration = 0.05 }
    },
    display = {
      budget = 1
    }
  }
}
