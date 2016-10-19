
require("stdlib.event.event")

require("config")

local world_data = {}
-- {
--   surface_name = "",
--   localised-name = "",
--   terrestrial = false,
--   map_gen_settings = nil, -- Merged with, and overwrites, nauvis map_gen_settings. Ssee api for details.
--   unlocked = false
-- }
local default_off_autoplace = {}
local starting_world = "nauvis"

-- Functions
local function get_starting_surface()
  return game.surfaces[ starting_world ]
end
local function teleport_to_world( world, player )
	if world == nil then
		player.teleport( player.position, game.surfaces[starting_world] )
		return
	end
	world.surface.request_to_generate_chunks( player.position, 0 )
	player.teleport( player.position, world.surface )
end

local function set_starting_world( name )
  starting_world = name
end
local function register_world( data )
  
end
local function unlock_world( data )
  
end

-- Events
script.on_init( function(event)
    
end)

local players_loading = {}
Event.register(defines.events.on_tick, function( event )
  local _new_list = {}
  local _surface = get_starting_surface()
  for _, _player in pairs(players_loading) do
    if _surface.is_chunk_generated( Chunk.from_position( _player.position ) ) then
      if _player.gui.center.loadingscreen then
        _player.gui.center.loadingscreen.destroy()
      end
      teleport_to_world( starting_world, _player )
    else
      -- update loading screen
      if not _player.gui.center.loadingscreen then
        _player.gui.center.add( {type="label", name="loadingscreen", caption="Additional Loading... please do no touch the controls"} )
      end
      table.insert( _new_list, _player )
    end
  end
  players_loading = _new_list
end)

Event.register(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  if player.surface.name == "nauvis" and starting_world ~= "nauvis" then
    get_starting_surface().request_to_generate_chunks( Chunk.from_position( player.position ), 4 )
    table.insert( players_loading, player )
  end
end)

-- Script Interface
remote.add_interface("k_worlds", {
  set_starting_world = function( surface_name )
    set_starting_world( surface_name )
  end,
  set_autoplace_control_off = function( control_name )
    default_off_autoplace[control_name] = true
  end,
  register_world = function( data )
    register_world( data )
  end,
  unlock_world = function( data )
    unlock_world( data )
  end
 })
