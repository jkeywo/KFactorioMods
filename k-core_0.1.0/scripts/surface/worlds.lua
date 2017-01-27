
World = {
  data = {},
-- ["surface_name"] = {
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
  starting = "nauvis",
  default_off_checked = false,
  default_off_controls = {},
  pending_teleports = {},
}

World.get_starting_surface = function()
  return game.surfaces[ World.starting ]
end

World.register = function( data )
  World.data[data.surface_name] = data
  
  if game.surfaces[data.surface_name] then
    return
  end
  
  -- generate surface if it doesn't exist already
  local nauvis = game.surfaces["nauvis"]
  local map_gen = table.deepcopy( nauvis.map_gen_settings )
  
  map_gen.terrain_segmentation = data.map_gen_settings.terrain_segmentation or map_gen.terrain_segmentation
  map_gen.water = data.map_gen_settings.water or map_gen.water
  map_gen.seed = data.map_gen_settings.seed or map_gen.seed
  map_gen.shift = data.map_gen_settings.shift or map_gen.shift
  map_gen.width = data.map_gen_settings.width or map_gen.width
  map_gen.height = data.map_gen_settings.height or map_gen.height
  map_gen.starting_area = data.map_gen_settings.starting_area or map_gen.starting_area
  map_gen.peaceful_mode = data.map_gen_settings.peaceful_mode or map_gen.peaceful_mode
  
  for _control, _ in pairs(World.default_off_controls) do
    map_gen.autoplace_controls[_control] =  { frequency = "none", size = "none", richness = "none" }
  end
  for _name, _control in pairs(data.map_gen_settings.autoplace_controls) do
    map_gen.autoplace_controls[_name] =  _control
  end
  
  game.create_surface( data.surface_name, map_gen )
end

World.unlock_world = function( data )
 global.worlds = global.worlds or {} 
 global.worlds[data.name] = global.worlds[data.name] or {}
 global.worlds[data.name].locked = false
end

World.teleport_to = function( world, player, position )
  World.pending_teleports[player.index] = World.pending_teleports[player.index] or {
      player = player
    }
    
  local _surface = (world and world.surface) or world or World.get_starting_surface()
  local _position = position or player.position
  World.pending_teleports[player.index].surface = _surface
  World.pending_teleports[player.index].position = _position
  
	world.surface.request_to_generate_chunks( Chunk.from_position( _position ), 4 )
end

World.cancel_teleport_to = function( player )
  World.pending_teleports[player.index] = nil
  if player.gui.center.loadingscreen then
    player.gui.center.loadingscreen.destroy()
  end
end

-- Events
Event.register(defines.events.on_tick, function( event )
  -- check for world generation error and report errors (required "none" controls)
  if not World.default_off_checked then
    local _autoplace_controls = game.surfaces["nauvis"].map_gen_settings.autoplace_controls
    for _control, _ in pairs(World.default_off_controls) do
      if _autoplace_controls[_control] and _autoplace_controls[_control].size ~= "none" then
        game.print(_control.." should be set to 'None' in the map settings, please generate a new world.")
      end
    end
    World.default_off_checked = true
  end
    
  -- update generation and teleporting
  local _new_list = {}
  local _surface = World.get_starting_surface()
  for _, _data in pairs(World.pending_teleports) do
    local _player = _data.player
    if _data.surface.is_chunk_generated( Chunk.from_position( _data.position ) ) then
      if _player.gui.center.loadingscreen then
        _player.gui.center.loadingscreen.destroy()
      end
      if not _player.teleport( _data.position, _data.surface ) then
        _player.print("Teleport failed, target invalid")
      end
    else
      -- update loading screen
      if not _player.gui.center.loadingscreen then
        _player.gui.center.add( {type="frame", name="loadingscreen", caption="Loading world, please wait."} )
      end
      table.insert( _new_list, _player )
    end
  end
  World.pending_teleports = _new_list
end)
