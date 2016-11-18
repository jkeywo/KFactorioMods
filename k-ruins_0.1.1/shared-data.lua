
obelisk_abilities = {
  {
    name="ability-teleport",
    sprite="__k-ruins__/graphics/obelisk/ability-teleport",
    tooltip="Teleport to where you click.",
    on_trigger=script and script.generate_event_name(),
    cooldown=60*Time.SECOND,
    type="target"
  },
  {
    name="ability-bubble",
    sprite="__k-ruins__/graphics/obelisk/ability-bubble",
    tooltip="Become invulnerable for 5 seconds.",
    on_trigger=script and script.generate_event_name(),
    cooldown=120*Time.SECOND,
    type="activate"
  },
  {
    name="ability-swarm",
    sprite="__k-ruins__/graphics/obelisk/ability-drone-swarm",
    tooltip="Summon a swarm of attack drones.",
    on_trigger=script and script.generate_event_name(),
    cooldown=240*Time.SECOND,
    type="activate"
  },
}