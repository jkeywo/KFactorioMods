
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

