
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
    speed = 0.3,
    ingredients = { {"grenade", 1} },
    stages =
    {
      { name = "A", sprite = "flare", explosion="flash", light = {intensity = 0.3, size = 80 }, duration = 60 }
    },
    display = nil
  },
  { 
    name = "firework-large", 
    cooldown = 30, 
    range = 50, 
    speed = 0.3, 
    ingredients = { {"grenade", 3} },
    stages =
    {
      { name = "A", sprite = "star", explosion="flash", light = { intensity = 0.9, size = 4 }, duration = 0.1, fragments = 24, fragment_distance = 12, fragment_speed = 0.2 },
      { name = "B", sprite = "spark", explosion="flash", light = { intensity = 0.9, size = 4 }, duration = 0.1 }
    },
    display = {
      budget = 3
    }
  },
  {
    name = "firework-medium",
    cooldown = 30, 
    range = 50, 
    speed = 0.3, 
    ingredients = { {"grenade", 2} },
    stages =
    {
      { name = "A", sprite = "star", light = { intensity = 0.9, size = 1 }, duration = 0.1, fragments = 8, fragment_distance = 8, fragment_speed = 0.2 },
      { name = "B", sprite = "spark", light = { intensity = 0.9, size = 1 }, duration = 0.1, fragments = 6, fragment_distance = 4, fragment_speed = 0.3 },
      { name = "C", sprite = "spark", explosion="flash", light = { intensity = 0.9, size = 1 }, duration = 0.1 }
    },
    display = {
      budget = 2
    }
  },
  { 
    name = "firework-small", 
    cooldown = 30, 
    range = 50, 
    speed = 0.3, 
    ingredients = { {"grenade", 1} },
    stages =
    {
      { name = "A", sprite = "star", smoke="sparks", light = { intensity = 0.9, size = 2 }, duration = 0.1, fragments = 12, fragment_distance = 8, fragment_speed = 0.3 },
      { name = "B", sprite = "spark", explosion="flash", smoke="sparks", light = { intensity = 0.9, size = 2 }, duration = 0.1 }
    },
    display = {
      budget = 1
    }
  }
}
