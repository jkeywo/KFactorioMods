
-- register data
remote.call("k-monuments", "register_monument", {
  name = "steam-geyser",
  entity_name = "steam-geyser-bare",
  default_floor = "sand",
  parent_mod_name = "k-ruins",
  position = {
    offset = { 300, 400 },
  },
  upgrades = {
    ["restored-steam-geyser"] = {
      entity_name = "steam-geyser-pump",
      attract_biters = {
        chance = { 0.0, 0.5 },
        cycle = 600 * Time.SECOND,
        count = { 1, 10 },
      }
    }
  }
})

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "steam-geyser-bare",
      component_entities = {
        { entity_name = "steam-geyser-bare", offset = { x=0, y=0 } },
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Steam Geyser" }
      }
    })

-- if the pump has created any water, make it 100 degrees
Event.register(defines.events.on_tick, function(event)
  local _entity = remote.call("k-monuments", "get_monument_entity", "steam-geyser")
  if _entity and _entity.valid and _entity.fluidbox then
    for i = 1, #_entity.fluidbox do
      if _entity.fluidbox[i] and _entity.fluidbox[i].temperature then
        local _box = _entity.fluidbox[i]
        _box.temperature = 100
        _entity.fluidbox[i] = _box
      end
    end
  end
end)