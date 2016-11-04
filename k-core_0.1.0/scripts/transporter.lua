
Transporter = {
  data = {}
-- ["entity_name"] = {
--  entity_name = "",
--  is_cave = "",                 -- world name
--  travel_type = "",             -- "teleport", "sequential", "rocket"
--  target_position = "",         -- "same", "fixed, "tag"
--  transport_player = {
--    type = "",                  -- "gui", "auto", "enter"
--    delay = 0.0,                -- delay before entering
--    area = {{0,0},{0,0}}        -- area within which you can be teleported
--  },
--  transport_points = {          -- list of points you can transport items from
--    { 
--      from_offset = {0, 0},
--      to = { target_position = "same", x = 0, y = 0 },
--      accepted_types = { "fluid", "items" }
--    }
--  },
--  target_tag = "",              -- entity_name to transport to
--  target_position = {0, 0},     -- fixed position to transport to
--  rocket_item = "",             -- item in inventory required to blast off
--  rocket_progress = 0.0,        -- rocket progress required for silos to blast off
-- }
}

Transporter.register = function( data )
  Transporter.data[data.entity_name] = data
end

