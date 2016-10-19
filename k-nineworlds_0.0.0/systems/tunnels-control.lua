
local M = {
    access_worlds = {}
  }

-- helpers
M.findTunnels = function ( position, radius, surface )
	local search_pos = (position and position.position) or position
	radius = radius or 2
	surface = surface or (position and position.surface) or game.surfaces["nauvis"]

	local range = { {search_pos.x-radius, search_pos.y-radius}, {search_pos.x+radius, search_pos.y+radius} }
	return surface.find_entities_filtered{area = range, name = "nw-tunnel"}
end

M.forEachTunnel = function(fn, position, radius, surface)
	for _tun in M.findTunnels( position, radius, surface ) do
		fn( _tun )
	end
end

-- event handlers
Event.register(defines.events.on_tick, function(event)
  for k,v in pairs(game.players) do
    local player = game.players[k]
    
    -- Create Frame
    local nineworlds_gui = player.gui.left.nineworlds_gui
    if nineworlds_gui == nil then
      player.gui.left.add( {type="frame", name="nineworlds_gui",
                  direction="horizontal", style="outer_frame_style"} )
      nineworlds_gui = player.gui.left.nineworlds_gui			
    end
    
    -- TODO change to mouse over for GUI and use the drive hotkey (on_player_driving_changed_state)
    local current_tunnels = M.findTunnels(player)
    local current_tunnel = nil
    if current_tunnels ~= nil and arraylength(current_tunnels) >= 1 then
      current_tunnel = current_tunnels[1]
    end
    for _, _world in pairs(M.access_worlds) do
      local can_travel = false
      local not_generated = false
      local current_surface = (_world.surface == player.surface)
      if current_tunnel ~= nil and not current_surface then
        local sub_tunnels = M.findTunnels(player, 2, _world.surface)
        can_travel = sub_tunnels ~= nil and arraylength(sub_tunnels) >= 1
        if not can_travel and _world.surface.can_place_entity{ name = "nw-tunnel", position = current_tunnel.position } then
          local new_entity = _world.surface.create_entity { name = "nw-tunnel", position = current_tunnel.position, force=player.force }
          new_entity.destructible = false
          new_entity.rotatable = false
          new_entity.minable = false
          new_entity.minable = (new_entity.surface == Midgard.surface)
          can_travel = true
        end
        not_generated = not _world.surface.is_chunk_generated( Chunk.from_position(current_tunnel.position) )
      end
      
      local button_name = "TVL".._world.surface.name
      if not current_surface and can_travel and not not_generated then
        if nineworlds_gui[button_name] == nil then
          nineworlds_gui.add( {type="button", name=button_name, caption="To ".._world.name} )
        end
      elseif nineworlds_gui[button_name] ~= nil then
        nineworlds_gui[button_name].destroy()
      end
      
      local text_name = "BLOCKED".._world.surface.name
      if not current_surface and not can_travel and not not_generated and current_tunnel ~= nil then
        if nineworlds_gui[text_name] == nil then
          nineworlds_gui.add( {type="label", name=text_name, caption=_world.name.." blocked"} )
        end
      elseif nineworlds_gui[text_name] ~= nil then
        nineworlds_gui[text_name].destroy()
      end
      local text2_name = "GEN".._world.surface.name
      if not current_surface and not_generated and current_tunnel ~= nil then
        if nineworlds_gui[text2_name] == nil then
          nineworlds_gui.add( {type="label", name=text2_name, caption=_world.name.." is generating..."} )
        end
      elseif nineworlds_gui[text2_name] ~= nil then
        nineworlds_gui[text2_name].destroy()
      end
   
    end
	end
end)

Event.register(defines.events.on_gui_click, function(event)
  local world_name, subs = string.gsub(event.element.name, "TVL", "", 1)
  if subs == 1 then
    local player = game.players[event.player_index]
    if world_name == "nauvis" then
      Worlds.teleportTo( nil, player )
    else
      Worlds.teleportTo( Worlds[world_name], player )
    end
  end
end)

Event.register(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	if entity.name ~= "nw-tunnel" then
		return
	end
	local player = game.players[event.player_index]
	local player_surface = player.surface
  
  for _, _world in pairs(M.access_worlds) do
    _world.surface.request_to_generate_chunks( Chunk.from_position(entity.position), 4)
  end
  
  local tunnel_list = {}
  table.insert(tunnel_list, entity )
  for _, _world in pairs(M.access_worlds) do
    if _world.surface ~= player_surface then
      -- create matching tunnel below the surface
      if _world.surface.can_place_entity{ name = "nw-tunnel", position = entity.position } then
        local new_entity = _world.surface.create_entity { name = "nw-tunnel", position = entity.position, force=player.force }
        table.insert( tunnel_list, new_entity )
      end
    end
  end
  
  for _, _tunnel in pairs(tunnel_list) do
    _tunnel.minable = (_tunnel.surface.name == "nauvis")
		_tunnel.rotatable = false
		_tunnel.destructible = false
  end
end)

Event.register({ 
      defines.events.on_preplayer_mined_item, 
      defines.events.on_preplayer_mined_item,
      defines.events.on_entity_died
    }, function(event)
  if event.entity.name == "nw-tunnel" then
    Linked.on_destroyed( event.entity )
  end
end)

return M
