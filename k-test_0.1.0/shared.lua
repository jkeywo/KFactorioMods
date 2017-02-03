
abilities = {
  {
    name = "teleport",
    sprite = "__k-test__/graphics/ability-teleport",
    energy = {
      cost = 1.0,
      reserve="internal"
    },
    on_trigger = script and script.generate_event_name() or nil,
    type = "target"
  },
  {
    name = "bubble",
    sprite = "__k-test__/graphics/ability-bubble",
    energy = {
      cost = 1.0, 
      reserve="building"
    },
    on_trigger = script and script.generate_event_name() or nil,
    type = "activate"
  }  
}
