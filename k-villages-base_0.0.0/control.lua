require("config")

-- Functions
local function register_village( data )
  remote.call( "k_momuments", "register_momument", {} )
end

-- Script Interface
remote.add_interface("k_villages", {
  register_village = function( data )
    register_village( data )
  end
})

-- Events
-- -- Initialise
script.on_init( function(event)
	-- Register Defaults
	if Config.enable_default_villages then
		-- add default village info
		-- register_village()
		-- register_village()
		-- register_village()
		-- register_village()
	end
end)

-- -- Tech complete
-- add default reveals after 2 hours, 4 hours, 8 hours and 16 hours
