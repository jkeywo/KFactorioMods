
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

firework_sprites = {
  ["none"] = {
    animation = function(colour_name) return {
        filename = "__fireworks__/graphics/blank.png",
        frame_count = 1,
        width = 32,
        height = 32,
        priority = "high"
    } end,
  },  
  ["star"] = {
    animation = function(colour_name) return {
        filename = "__fireworks__/graphics/projectiles/firework-star-"..colour_name..".png",
        frame_count = 1,
        width = 64,
        height = 64,
        priority = "high"
    } end,
  },
  ["spark"] = {
    animation = function(colour_name) return {
        filename = "__fireworks__/graphics/projectiles/firework-spark-"..colour_name..".png",
        frame_count = 1,
        width = 32,
        height = 32,
        priority = "high"
    } end,
  },
  ["flare"] = {
    animation = function(colour_name) return {
        filename = "__fireworks__/graphics/projectiles/flare-"..colour_name..".png",
        frame_count = 1,
        width = 64,
        height = 64,
        priority = "high"
    } end,
  },
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
      { suffix = "", sprite = "flare", light = {intensity = 0.3, size = 80 }, duration = 60 }
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
      { suffix = "", sprite = "star", light = { intensity = 0.9, size = 4 }, duration = 0.1, fragments = 24, fragment_distance = 12, fragment_speed = 0.3 },
      { suffix = "-sparks", sprite = "spark", light = { intensity = 0.9, size = 4 }, duration = 0.1 }
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
      { suffix = "", sprite = "star", light = { intensity = 0.9, size = 1 }, duration = 0.1, fragments = 8, fragment_distance = 8, fragment_speed = 0.3 },
      { suffix = "-sub", sprite = "spark", light = { intensity = 0.9, size = 1 }, duration = 0.1, fragments = 6, fragment_distance = 4, fragment_speed = 0.4 },
      { suffix = "-sparks", sprite = "spark", light = { intensity = 0.9, size = 1 }, duration = 0.1 }
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
      { suffix = "", sprite = "star", light = { intensity = 0.9, size = 2 }, duration = 0.1, fragments = 12, fragment_distance = 8, fragment_speed = 0.4 },
      { suffix = "-sparks", sprite = "spark", light = { intensity = 0.9, size = 2 }, duration = 0.1 }
    },
    display = {
      budget = 1
    }
  }
}
