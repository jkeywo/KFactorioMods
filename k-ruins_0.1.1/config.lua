Config = {
  obelisks = {
      { modifier="character_running_speed_modifier", amount=0.2 },
      { modifier="character_health_bonus", amount=25 },
      { modifier="character_inventory_slots_bonus", amount=20 },
    },
  world_tree = true,
  steam_geyser = true,
  munitions_manufactory = true,
  rocket_silo = true,
  deep_mine = true,
  war_shrine =
  {
    kills_per_rank = { 10, 30, 60 },
    decay_per_tick = { -0.1, -0.1, -0.3, -1.0 },
    buff_effects = {
      { modifier="character_running_speed_modifier", amount=0.3  },
      { modifier="character_health_bonus", amount=50, regeneration=5 },
      { regeneration=5, death_aura=100 }
    }
  },
}