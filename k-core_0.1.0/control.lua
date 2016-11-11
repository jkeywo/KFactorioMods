
require("stdlib.area.area")
require("stdlib.area.chunk")
require("stdlib.area.position")
require("stdlib.area.tile")
require("stdlib.event.event")

require("config")
require("shared-data")

if Config["abilities"] then
  require("scripts.abilities")
end
if Config["composite-entities"] then
  require("scripts.composite-entities")
end
if Config["missions"] then
  require("scripts.missions")
end
if Config["monuments"] then
  require("scripts.monuments")
end
if Config["units"] then
  require("scripts.units")
end
if Config["worlds"] then
  require("scripts.worlds")
  require("scripts.transporter")
end

-- interfaces
remote.add_interface( "k-composite-entities", {
    register_composite = function( data )
      CompositeEntities.register_composite( data )
    end,
    get_linked_entities = function( entity )
      return global.composite_entity_parent[entity].entity_list
    end,
    get_composite_data = function( entity )
      return CompositeEntities.data[ global.composite_entity_parent[entity].type ]
    end,
    on_create = function( entity )
      CompositeEntities.create_linked( entity )
    end,
    on_destroyed = function( entity )
      CompositeEntities.destroy_linked( entity )
    end,
  })

remote.add_interface("k-monuments", {
  register_monument = function( data )
    Monument.register( data )
  end,
  reveal_monument = function( name )
    Monument.reveal( name )
  end,
  upgrade_monument = function( name, upgrade_name )
    Monument.upgrade( name, upgrade_name )
  end,
  downgrade_monument = function( name )
    Monument.downgrade( name )
  end,
  get_monument_entity = function( name )
    return Monument.get_entity( name )
  end,
  get_monument_data = function( name )
    return Monument.data[name]
  end,
  get_global_data = function( name )
    return Monument.get_global_data( name )
  end
 })

remote.add_interface("k-worlds", {
  set_starting_world = function( surface_name )
    World.starting = surface_name
  end,
  set_autoplace_control_off = function( control_name )
    World.default_off_controls[control_name] = true
  end,
  register_world = function( data )
    World.register( data )
  end,
  register_transporter = function( data )
    Transporter.register( data )
  end,
  unlock_world = function( data )
    World.unlock( data )
  end
 })

remote.add_interface("k-abilities", {
  register_ability = function( data )
    Abilities.register_ability( data )
  end,
  add_ability = function( player, name )
    Abilities.add_ability( player, name )
  end,
  remove_ability = function( player, name )
    Abilities.remove_ability( player, name )
  end,
 })