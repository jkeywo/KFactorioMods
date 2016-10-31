
-- register data
remote.call("k-monuments", "register_monument", {
    name = "world-tree",
    entity_name = "world-tree-dead",
    parent_mod_name = "k-monuments-ruins",
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