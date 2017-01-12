

test_abilities = {
  {
    name="test-ability-teleport",
    sprite="__k-ruins__/graphics/obelisk/ability-teleport",
    tooltip="Teleport to where you click.",
    on_trigger=script and script.generate_event_name(),
    cooldown=6*60,
    type="target"
  },
  {
    name="test-ability-swarm",
    sprite="__k-ruins__/graphics/obelisk/ability-drone-swarm",
    tooltip="Summon a swarm of attack drones.",
    on_trigger=script and script.generate_event_name(),
    cooldown=24*60,
    type="activate"
  },
}