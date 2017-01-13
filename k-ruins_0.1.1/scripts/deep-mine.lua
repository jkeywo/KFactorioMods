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
        on_tick = script.generate_event_name(),
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
        { entity_name = "invisible-label-1x1", offset = { x=-1, y=-1 }, operable=false, lable="Ruined Mine" },
      }
    })

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine",
      destroy_origional = false,
      component_entities = {
        { entity_name = "iron-chest", offset = { x=-2, y=3 }, operable=false },
        { entity_name = "loader", offset = { x=-2, y=1 }, operable=false, type="output" },
        { entity_name = "iron-chest", offset = { x=2, y=3 }, operable=false },
        { entity_name = "loader", offset = { x=2, y=1 }, operable=false, type="output" },
      }
    })
  
Event.register(_data.upgrades["restored-deep-mine"].on_tick, function(event)
  if event.tick % 60 == 1 then
    -- fill chests
    local _mine_parts = event.entity and remote.call( "k-composite-entities", "get_linked_entities", event.entity ) or nil
    if not _mine_parts then return end
    local index = 0
    for _, _entity in pairs(_mine_parts) do
      if _entity.type == "container" then
        local _inventory = _entity.get_inventory(defines.inventory.chest)
        if index == 0 then
          if _inventory.get_item_count("iron-ore") < 40 then
            _inventory.insert({name="iron-ore", count=40})
          end
        elseif index == 1 then
          if _inventory.get_item_count("copper-ore") < 40 then
            _inventory.insert({name="copper-ore", count=40})
          end
        end
        index = index + 1
      end
    end        
  end
end)
