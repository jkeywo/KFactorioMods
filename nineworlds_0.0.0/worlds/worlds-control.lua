local worlds = {
}

-- functions
worlds.teleportTo = function( world, player )
	if world == nil then
		player.teleport( player.position, game.surfaces["nauvis"] )
		return
	end
	
	world.surface.request_to_generate_chunks( player.position, 0 )
	world.surface.request_to_generate_chunks( player.position, 4 )
	player.teleport( player.position, world.surface )
end

-- events
Event.register(defines.events.on_tick, function(event)

end)

return worlds
