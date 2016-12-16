Config = {
  obelisks = 3,
  world_tree = true,
  steam_geyser = true,
  munitions_manufactory = true,
  rocket_silo = true,
  deep_mine = false,
  war_shrine = 
  {
    rank_sprite = { 
      "__base__/graphics/icons/signal/signal_0.png",
      "__base__/graphics/icons/signal/signal_1.png",
      "__base__/graphics/icons/signal/signal_2.png",
      "__base__/graphics/icons/signal/signal_3.png"
    },
    kills_per_rank = { 10, 30, 60, 80 },
    decay_per_tick = { -0.1, -0.2, -0.5, -1.0 },
    buff_effects = {
      { modifier="character_running_speed_modifier", amount=0.3  },
      { modifier="character_health_bonus", amount=50, regeneration=5 },
      { regeneration=5, death_aura=100 }
    },
  },
}