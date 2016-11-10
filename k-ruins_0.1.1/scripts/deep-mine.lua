-- register data
local _data = {
    name = "deep-mine",
    entity_name = "deep-mine-ruined",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 50, 80 },
    },
    upgrades = {
      ["restored-deep-mine"] = {
        entity_name = "deep-mine",
        attract_biters = {
          chance = 0.5,
          cycle = 90 * Time.SECOND,
          count = { 2, 40 },
        },
      }
    }
  }
  
remote.call( "k-monuments", "register_monument", _data )

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine-ruined",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Mine" },
      }
    })

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine",
      destroy_origional = false,
      component_entities = {
        { entity_name = "deep-mine-near-drill", offset = { x=-1, y=1 }, operable=false },
        { entity_name = "deep-mine-iron-ore", offset = { x=-1, y=1 } },
        { entity_name = "deep-mine-far-drill", offset = { x=-1, y=0 }, operable=false },
        { entity_name = "deep-mine-iron-ore", offset = { x=-1, y=0 } },
        { entity_name = "deep-mine-near-drill", offset = { x=1, y=1 }, operable=false },
        { entity_name = "deep-mine-copper-ore", offset = { x=1, y=1 } },
        { entity_name = "deep-mine-far-drill", offset = { x=1, y=0 }, operable=false },
        { entity_name = "deep-mine-copper-ore", offset = { x=1, y=0 } },
      }
    })
