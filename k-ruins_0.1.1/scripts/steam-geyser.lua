
-- register data
local _data = {
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
      on_tick = script.generate_event_name(),
      attract_biters = {
        chance = { 0.0, 0.5 },
        cycle = 600 * Time.SECOND,
        count = { 1, 10 },
      }
    }
  }
}
remote.call("k-monuments", "register_monument", _data)

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "steam-geyser-bare",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Steam Geyser" }
      }
    })

-- if the pump has created any water, make it 100 degrees
Event.register(_data.upgrades["restored-steam-geyser"].on_tick, function(event)
  if event.entity and event.entity.valid and event.entity.fluidbox then
    for i = 1, #event.entity.fluidbox do
      if event.entity.fluidbox[i] and event.entity.fluidbox[i].temperature then
        local _box = event.entity.fluidbox[i]
        _box.temperature = 100
        event.entity.fluidbox[i] = _box
      end
    end
  end
end)