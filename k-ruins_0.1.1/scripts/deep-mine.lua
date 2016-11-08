-- register data
remote.call("k-monuments", "register_monument", {
    name = "deep-mine",
    entity_name = "deep-mine-ruined",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 500, 800 },
    },
    upgrades = {
      ["restored-deep-mine"] = {
        entity_name = "deep-mine",
        attract_biters = {
          chance = 0.5,
          cycle = 90 * Time.SECOND,
          count = { 2, 40 },
        }
      }
    }
  })

local iron_chest_offset = { x-2, y=0 }
local copper_chest_offset = { x2, y=0 }
remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine",
      component_entities = {
        { entity_name = "invisible-label-5x1", offset = { x=-2, y=-2 }, operable=false, lable="Ruined Munitions Manufactory" }
        { entity_name = "deep-mine", offset = { x=-2, y=1 }, operable=false }
        { entity_name = "wooden-chest", offset = iron_chest_offset, operable=false }
        { entity_name = "loader", offset = { x=2, y=1 }, operable=false }
        { entity_name = "wooden-chest", offset = copper_chest_offset, operable=false }
      }
    })
  
Event.register(defines.events.on_tick, function(event)
  if game.tick % 60 == 0 then
    -- iron
    local _surface = game.surfaces["nauvis"]
    local _global_data = remote.call("k-monuments", "get_global_data", "deep-mine")
    local _position = Position.add( _global_data.position, iron_chest_offset )
    local _entity = _surface.find_entity("wooden-chest",_position)
    if _entity then
      local _inventory = _entity.get_inventory(defines.inventory.chest)
      if _inventory and _inventory.get_item_count("iron-ore") < 40 then
        _inventory.insert( {name="iron-ore", count=40} )
      end
    end
  elseif game.tick % 60 == 30 then
    -- copper
    local _surface = game.surfaces["nauvis"]
    local _global_data = remote.call("k-monuments", "get_global_data", "deep-mine")
    local _position = Position.add( _global_data.position, copper_chest_offset )
    local _entity = _surface.find_entity("wooden-chest",_position)
    if _entity then
      local _inventory = _entity.get_inventory(defines.inventory.chest)
      if _inventory and _inventory.get_item_count("copper-ore") < 40 then
        _inventory.insert( {name="copper-ore", count=40} )
      end
    end
  end
})