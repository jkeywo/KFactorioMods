require("config")

-- Functions
local function register_world( data )
end
local function unlock_world( data )
end

-- Script Interface
remote.add_interface("k_worlds", {
  register_world = function( data )
    register_world( data )
  end,
  unlock_world = function( data )
    unlock_world( data )
  end
 })

-- Events
-- -- Initialise
script.on_init( function(event)
	-- Register Defaults
	if Config.enable_default_worlds then
		-- add default world info
		-- register_momument()
	end
end)

-- -- Rocket launched
-- add space world

