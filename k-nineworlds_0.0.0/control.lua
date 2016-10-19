-- factorio libs
require "util"
require "config"

-- std libs
require("stdlib.area.area")
require("stdlib.area.position")
require("stdlib.area.chunk")
require("stdlib.entity.entity")
require("stdlib.event.event")
require("stdlib.table")

-- config
DEBUG = true

-- nw libs
require("lib.core")
Scheduler = require("lib.scheduler")

-- systems
Linked = require("systems.linked-control")
Tunnels = require("systems.tunnels-control")
Logistics = require("systems.logistics-control")

-- worlds
Worlds = require("worlds.worlds-control")
Midgard = require("worlds.midgard-control")
Nidavellir = require("worlds.nidavellir-control")
Svartalfheim = require("worlds.svartalfheim-control")

-- setup links between terrestrial worlds
Midgard.links.down = Nidavellir
Midgard.links.up = nil

Nidavellir.links.down = Svartalfheim
Nidavellir.links.up = Midgard

Svartalfheim.links.down = nil
Svartalfheim.links.up = Nidavellir

-- events
local players_loading = {}
Event.register(defines.events.on_tick, function( event )
  local _new_list = {}
  for _, _player in pairs(players_loading) do
    if Midgard.surface.is_chunk_generated( Chunk.from_position( _player.position ) ) then
      if _player.gui.center.loadingscreen then
        _player.gui.center.loadingscreen.destroy()
      end
      Worlds.teleportTo( Midgard, _player )
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
  if player.surface.name == "nauvis" then
    Midgard.surface.request_to_generate_chunks( Chunk.from_position( player.position ), 4 )
    table.insert( players_loading, player )
  end
end)
