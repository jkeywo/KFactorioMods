
require("stdlib.event.event")

local world_data = {}
-- {
--   surface_name = "",       -- Surface name, also used internally as the world name.
--   localised_name = "",     -- Localised name tag.
--   locked = false,          -- Starts locked?
--   tags = { "", "" }        -- Tags to enable/disable items.
--   sequential_travel = {    -- Surfaces arranged as sequential layers.
--     previous_world = "",   -- -- The surface before this one.
--     next_world = "",       -- -- The surface after this one.
--     infinite = false,      -- -- Continue creating worlds, with appended indexes (1, 2, 3, etc.)
--   },
--   teleport_from_world = { "" }, -- Surfaces you can teleport here from.
--   rocket_from_worlds = { "" },  -- Surfaces you can rocket here from.
--   is_cave = false,              -- A new cave surface is created per cave entity and you can travel to it only
--                                 -- - from that entity. if this is true other travel settings should be false.
--   map_gen_settings = nil,  -- Merged with, and overwrites, nauvis map_gen_settings. See api for details.
--   unlocked = false
-- }
local transporter_data = {}
-- {
--  entity_name = "",
--  is_cave = "",                 -- world name
--  travel_type = "",             -- "teleport", "sequential", "rocket"
--  target_position = "",         -- "same", "fixed, "tag"
--  transport_player = {
--    type = "",                  -- "gui", "auto", "enter"
--    delay = 0.0,                -- delay before entering
--    area = {{0,0},{0,0}}        -- area within which you can be teleported
--  },
--  transport_items = { { from = {0, 0}, to = {0, 0} } },
--  transport_fluids = { { from = {0, 0}, to = {0, 0} } },
--  target_tag = "",              -- entity_name to transport to
--  target_position = {0, 0},     -- fixed position to transport to
--  rocket_item = "",             -- item in inventory required to blast off
-- }

local starting_world = "nauvis"
local default_off_autoplace = {}
local players_loading = {}

-- Functions
local function set_starting_world( name )
  starting_world = name
end

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

local function register_world( data )
  world_data[data.name] = data
end

local function register_transporter( data )
  transporter_data[data.entity_name] = data
end

local function unlock_world( data )
 global.worlds = global.worlds or {} 
 global.worlds[data.name] = global.worlds[data.name] or {}
 global.worlds[data.name].locked = false
end

-- Events
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
remote.add_interface("k-worlds", {
  set_starting_world = function( surface_name )
    set_starting_world( surface_name )
  end,
  set_autoplace_control_off = function( control_name )
    default_off_autoplace[control_name] = true
  end,
  register_world = function( data )
    register_world( data )
  end,
  register_transporter = function( data )
    register_transporter( data )
  end,
  unlock_world = function( data )
    unlock_world( data )
  end
 })
