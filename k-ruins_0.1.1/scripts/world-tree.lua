
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

-- no events

-- no way to reveal