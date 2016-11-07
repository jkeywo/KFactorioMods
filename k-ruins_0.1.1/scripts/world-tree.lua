
-- register data
remote.call("k-monuments", "register_monument", {
    name = "world-tree",
    entity_name = "world-tree-dead",
    default_floor = "grass",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 300, 500 },
    },
    upgrades = {
      ["restored-world-tree"] = {
        entity_name = "world-tree"
      }
    }
  })

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "world-tree-dead",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Yggdrasil's Corpse" }
      }
    })

local base_area = Area.construct(-0.5, -0.5, 0.5, 0.5)
local entity_list = { "tree-01", "tree-02", "tree-03", "tree-04", "tree-05", "tree-06" }

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "tree-cluster",
      keep_cluster = false,
      component_entities = {
        { entity_name = entity_list, offset_area = base_area, can_fail = true },
        { entity_name = entity_list, offset_area = Area.offset( base_area, { -1.0, -1.0 } ), can_fail = true },
        { entity_name = entity_list, offset_area = Area.offset( base_area, { -1.0, 1.0 } ), can_fail = true },
        { entity_name = entity_list, offset_area = Area.offset( base_area, { 1.0, -1.0 } ), can_fail = true },
        { entity_name = entity_list, offset_area = Area.offset( base_area, { 1.0, 1.0 } ), can_fail = true },
      }
    })