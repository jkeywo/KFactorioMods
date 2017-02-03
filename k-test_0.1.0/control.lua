
require("config")

-- Composite Entity
remote.call( "k-composite-entities", "register", {
    base_entity = "composite-entity",
    destroy_origional = false,
    component_entities = {
      { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Composite Entity" }
    }
  })

-- Static Entity
remote.call( "k-static-entities", "register", {
    name = "static-entity",
    entity_name = "static-entity",
    default_floor = "grass",
    position = {
      offset = { 10, 10 },
    }
  })

-- Upgradable Entity
remote.call( "k-upgradable-entities", "register", {
    name = "assembling-machine-1",
    upgrades = {
      ["upgrade-entity-1-2"] = "assembling-machine-2",
      ["upgrade-entity-1-3"] = "assembling-machine-3"
    }
  })
remote.call( "k-upgradable-entities", "register", {
    name = "assembling-machine-2",
    downgrade_to = "assembling-machine-1",
    upgrades = {
      ["upgrade-entity-1-3"] = "assembling-machine-3"
    }
  })
remote.call( "k-upgradable-entities", "register", {
    name = "assembling-machine-3",
    downgrade_to = "assembling-machine-2"
  })

-- Biter Attractor Entity
remote.call( "k-entity-events", "register", {
    name = "biter-entity",
    attract_biters = {
      chance = 0.8,
      cycle = 10 * 60,
      count = { 1, 2 },
    }
  })

-- Abilities
require("shared")
-- teleport (click to move)
remote.call( "k-abilities", "register_ability", abilities[1])
-- bubble (toggle to drain energy from buildings)
remote.call( "k-abilities", "register_ability", abilities[2])

remote.call( "k-abilities", "register_reserve", {
  name = "internal",
  type = "internal",
  sprite = "item/teleport",
  recharge = 0.1 / 60.0,
  max = 5.0,
})

remote.call( "k-abilities", "register_reserve", {
  name = "building",
  type = "building",
  sprite = "item/bubble",
})

remote.call( "k-abilities", "register_building", {
  name = "roboport",
  reserve = "building",
  abilities = { "bubble" }
})

script.on_event(defines.events.on_player_created, function(event)
  remote.call( "k-abilities", "add_ability", game.players[event.player_index], abilities[1].name )
end)

-- teleport player
script.on_event(abilities[1].on_trigger, function(event)
  event.player.teleport(event.target)
end)

-- toggle bubble buff
script.on_event(abilities[2].on_trigger, function(event)
  local _buff = remote.call( "k-buffs", "get_buff", "bubble", event.player )
  if _buff then
    remote.call( "k-buffs", "remove", "bubble", event.player )
  else
    remote.call( "k-buffs", "apply", "bubble", event.player )
  end
end)

local _bubble_buff = {
  name = "bubble",
  sprite = "item/bubble",
  energy = { reserve = "building", drain = 1.0 },
  on_start = script.generate_event_name(),
  on_end = script.generate_event_name()
}
remote.call( "k-buffs", "register", _bubble_buff )

script.on_event(_bubble_buff.on_start, function(event)
  event.player.character.destructible = false
end)
script.on_event(_bubble_buff.on_end, function(event)
  event.player.character.destructible = true
end)
