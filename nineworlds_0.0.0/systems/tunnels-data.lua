
-- nw-tunnel
data:extend(
{
 {
    type = "item",
    name = "nw-tunnel",
    icon = "__nineworlds__/graphics/icon_nif_tunnel.png",
    flags = { "goes-to-quickbar" },
    subgroup = "portals",
    place_result="nw-tunnel",
    stack_size= 1,
  },
  {
    type = "recipe",
    name = "nw-tunnel",
    enabled = "false",
    ingredients = 
    {
      {"stone",50},
      {"iron-stick",10}
    },
    result = "nw-tunnel"
  },
  {
    type = "simple-entity",
    name = "nw-tunnel",
    icon = "__nineworlds__/graphics/icon_nif_tunnel.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "nw-tunnel"},
    render_layer = "object",
    max_health = 200,
    collision_box = {{-0, -0}, {0, 0}},
    selection_box = {{-1, -1}, {1, 1}},
    pictures =
    {
      {
        filename = "__nineworlds__/graphics/entity_nidavellir_tunnel.png",
        width = 32,
        height = 32,
        shift = {0.1, 0}
      }
    },
  }
})
