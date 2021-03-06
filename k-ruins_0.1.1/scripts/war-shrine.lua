
-- register data
local _static_data = {
    name = "war-shrine",
    entity_name = "war-shrine-ruined",
    position = {
      offset = { 500, 800 },
    }
  }
local _upgrade_data = {
    name = "war-shrine-ruined",
    upgrades = {
      ["restored-war-shrine"] = {
        entity_name = "war-shrine",
      }
    }
  }
local _event_data = {
    name = "war-shrine",
    attract_biters = {
      chance = 0.5,
      cycle = 600 * Time.SECOND,
      count = { 10, 100 },
    }
  }
local _composite_data = {
      base_entity = "war-shrine-ruined",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Shrine" }
      }
    }

remote.call( "k-static-entities", "register", _static_data )
remote.call( "k-upgradable-entities", "register", _upgrade_data )
remote.call( "k-entity-events", "register", _event_data )
remote.call( "k-composite-entities", "register", _composite_data )

-- global.war_shrine.buff_amount = 0.0
-- global.war_shrine.buff_rank = 0

local function update_buffs( delta )
  global.war_shrine = global.war_shrine or { buff_amount = 0.0, buff_rank = 0 }
  
  global.war_shrine.buff_amount = global.war_shrine.buff_amount + delta
  global.war_shrine.buff_amount = math.max(global.war_shrine.buff_amount, 0)
  global.war_shrine.buff_amount = math.min(global.war_shrine.buff_amount, Config.war_shrine.kills_per_rank[#Config.war_shrine.kills_per_rank])
  
  local _rank = 0
  for i = 1, (#Config.war_shrine.kills_per_rank - 1) do
    if global.war_shrine.buff_amount >= Config.war_shrine.kills_per_rank[i] then
      _rank = i
    end
  end
  
  local _force = game.forces["player"]

  if _rank < global.war_shrine.buff_rank then
    for i = _rank+1, global.war_shrine.buff_rank do
      -- strip buffs
      if Config.war_shrine.buff_effects[i].modifier then
        local _modifier = _force[Config.war_shrine.buff_effects[i].modifier]
        if _modifier then
          _modifier = _modifier - Config.war_shrine.buff_effects[i].amount
          _force[Config.war_shrine.buff_effects[i].modifier] = _modifier
        end
      end
    end
  elseif _rank > global.war_shrine.buff_rank then
    for i = global.war_shrine.buff_rank + 1, _rank do
      -- add buffs
      if Config.war_shrine.buff_effects[i].modifier then
        local _modifier = _force[Config.war_shrine.buff_effects[i].modifier]
        if _modifier then
          _modifier = _modifier + Config.war_shrine.buff_effects[i].amount
          _force[Config.war_shrine.buff_effects[i].modifier] = _modifier
        end
      end
    end
  end
  global.war_shrine.buff_rank = _rank
end
  
Event.register(defines.events.on_entity_died, function(event)
  local _global_data =  remote.call( "k-static-entities", "get_global_data", "war-shrine" )
  if not _global_data or not _global_data.upgrade_name then
    return
  end
    
  if event.force.name == "player" and event.entity.force.name == "enemy" then
    global.war_shrine = global.war_shrine or { buff_amount = 0.0, buff_rank = 0 }
    -- incriment buff amount
    update_buffs( 1.0 )
  end
end)

Event.register(defines.events.on_tick, function(event)

  global.war_shrine = global.war_shrine or { buff_amount = 0.0, buff_rank = 0 }
  
  -- decriment buff amount
  update_buffs( Config.war_shrine.decay_per_tick[global.war_shrine.buff_rank + 1] / Time.SECOND )
  
  local _regen = Config.war_shrine.buff_effects[global.war_shrine.buff_rank] 
              and Config.war_shrine.buff_effects[global.war_shrine.buff_rank].regeneration or nil
  if _regen then
    -- update regen if it's active
    for _, _player in pairs(game.players) do
      _player.character.health = _player.character.health + (_regen / Time.SECOND)
    end
  end
  
  local _death_aura = Config.war_shrine.buff_effects[global.war_shrine.buff_rank] 
                  and Config.war_shrine.buff_effects[global.war_shrine.buff_rank].death_aura or nil
  if _death_aura then
    -- update death aura if it's active
    local _enemy_force = game.forces["enemy"]
    for _, _player in pairs(game.players) do
      local _enemies = _player.surface.find_entities_filtered { 
            area = Position.expand_to_area(_player.character.position, 5), force = "enemy" }
      for _, _enemy in pairs(_enemies) do
        _enemy.damage( _death_aura / Time.SECOND, _player.force )
      end
    end
  end

  -- HUD
  for _, _player in pairs(game.players) do
    if global.war_shrine.buff_amount > 0.0 then
      if _player.gui.left.war_shrine then _player.gui.left.war_shrine.destroy() end
      
      local _rank_min = global.war_shrine.buff_rank == 0 and 0 or Config.war_shrine.kills_per_rank[global.war_shrine.buff_rank]
      local _rank_max = Config.war_shrine.kills_per_rank[global.war_shrine.buff_rank + 1]
      
      _player.gui.left.add { name="war_shrine", type="frame", direction="vertical" }
      _player.gui.left.war_shrine.add { name="rank_icon", type="sprite", 
              sprite="war_shrine_rank_"..global.war_shrine.buff_rank }
      _player.gui.left.war_shrine.add { name="progress", type="progressbar", 
              size= 32, value=(global.war_shrine.buff_amount-_rank_min)/(_rank_max-_rank_min) }
            
    elseif _player.gui.left.war_shrine then
      _player.gui.left.war_shrine.destroy()
    end
  end
end)




