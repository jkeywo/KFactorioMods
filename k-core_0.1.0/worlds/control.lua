
-- std lib
require("stdlib.event.event")

-- scripts
require("worlds.world")
require("worlds.transporter")

-- Script Interface
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
