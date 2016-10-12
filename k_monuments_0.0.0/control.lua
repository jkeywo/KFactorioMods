
require("config")

-- std lib
require("stdlib.area.chunk")
require("stdlib.event.event")

-- data
local monument_data = {}
-- name
-- distance
-- surface
-- entity-name
-- renovated-entity-name
-- renovation-recipe
-- default flooring

-- Functions
local function register_momument( data )
  monument_data[data.name] = monument_data
  -- resolve position to an actual position
end
local function reveal_momument( name )
  if not monument_data[name] then
    return
  end
  local _surface = game.surfaces[monument_data[name].surface or "nauvis"]
  if not _surface.is_chunk_generated( Chunk.from_position( monument_data[name].position ) ) then
    game.print( name.." has been revealed" )
  end
  _surface.request_to_generate_chunks( monument_data[name].position, 1 )
end

-- Events
Event.register(defines.events.on_chunk_generated, function(event)
  for _, _monument in monument_data do
    -- generate if contains the right position
    
    -- find somewhere passible we can place it
    -- otherwise create a concrete plinth for it
    -- clear area of doodads and other entities
    -- place monument
  end
end)

-- Default Monuments
if Config.enable_default_momuments then
  register_momument({
      name = "default-pyramid",
      distance = { 100, 150},
    })
  register_momument({
      name = "default-statue",
      distance = { 200, 250},
    })
  register_momument({
      name = "default-temple",
      distance = { 300, 350},
    })
  
  Event.register(defines.events.on_research_finished, function(event)
    local _ingredients = event.research.research_unit_ingredients
    for _, _ingredient in _ingredients do
      if _ingredient.name == "science-pack-1" then
        reveal_momument("default-pyramid")
      elseif _ingredient.name == "science-pack-2" then
        reveal_momument("default-statue")
      elseif _ingredient.name == "science-pack-3" then
        reveal_momument("default-temple")
      end
    end
  end)
end

-- Script Interface
remote.add_interface("k_momuments", {
  register_momument = function( data )
    register_momument( data )
  end,
  reveal_momument = function( data )
    reveal_momument( data )
  end
 })


