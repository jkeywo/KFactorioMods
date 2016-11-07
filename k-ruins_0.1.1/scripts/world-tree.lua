
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
      component_entities = {
        { entity_name = "world-tree-dead", offset = { x=0, y=0 } },
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Yggdrasil's Corpse" }
      }
    })

Event.register(defines.events.on_trigger_created_entity, function(event)
  
end)
