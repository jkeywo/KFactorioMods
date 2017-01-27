-- std lib
require("stdlib.area.area")
require("stdlib.area.chunk")
require("stdlib.area.position")
require("stdlib.area.tile")
require("stdlib.entity.entity")
require("stdlib.event.event")
require("stdlib.time")
-- k core lib
require("scripts.lib")
require("scripts.scheduler")

-- setup
require("config")
require("shared-data")

-- modules
if Config["character"] then
  require("scripts.character.abilities")
  require("scripts.character.buffs")
end

if Config["entity"] then
  require("scripts.entity.composite-entities")
  require("scripts.entity.entity-events")
  require("scripts.entity.static-entities")
  require("scripts.entity.upgradable-entities")
end

if Config["surface"] then
  require("scripts.surface.worlds")
  require("scripts.surface.transporter")
end

if Config["missions"] then
  require("scripts.missions")
end

if Config["units"] then
  require("scripts.units")
end

-- interfaces
if Config["entity"] then
  remote.add_interface( "k-composite-entities", {
    register = function( data )
      CompositeEntities.register_composite( data )
    end,
    get_linked = function( entity )
      return global.composite_entity_parent[entity] and global.composite_entity_parent[entity].entity_list or nil
    end,
    get_data = function( entity )
      return CompositeEntities.data[ global.composite_entity_parent[entity].type ]
    end,
    on_create = function( entity )
      CompositeEntities.create_linked( entity )
    end,
    on_destroyed = function( entity )
      CompositeEntities.destroy_linked( entity )
    end,
  })

  remote.add_interface("k-static-entities", {
    register = function( data )
      StaticEntity.register( data )
    end,
    reveal = function( name )
      StaticEntity.reveal( name )
    end,
    get_entity = function( name )
      return StaticEntity.get_entity( name )
    end,
    get_data = function( name )
      return StaticEntity.data[name]
    end,
    get_global_data = function( name )
      return StaticEntity.get_global_data( name )
    end
   })

  remote.add_interface("k-entity-events", {
    register = function( data )
      EntityEvent.register( data )
    end,
   })
  remote.add_interface("k-upgradable-entities", {
    register = function( data )
      UpgradableEntity.register( data )
    end,
   })
end

if Config["surface"] then
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
end

if Config["character"] then
  remote.add_interface("k-abilities", {
    register_ability = function( data )
      Abilities.register_ability( data )
    end,
    register_reserve = function( data )
      Abilities.register_reserve( data )
    end,
    register_building = function( data )
      Abilities.register_building( data )
    end,
    add_ability = function( player_or_force, name )
      Abilities.player[name]:add( player_or_force )
    end,
    remove_ability = function( player_or_force, name )
      Abilities.player[name]:remove( player_or_force )
    end,
   })
  remote.add_interface("k-buffs", {
    register = function( data )
      Buffs.register( data )
    end,
    apply = function( name, player )
      Buffs.data[name]:apply( player )
    end
   })
end

remote.add_interface("k-scheduler", {
    add_callback = function( delay, event_id, data, persistent )
        Scheduler.add_callback( delay, event_id, data, persistent )
    end,
    remove_callback = function( event_id )
        Scheduler.remove_callback( event_id )
    end,
 })