
data:extend(
{
  {
    type = "item",
    name = "targeter",
    icon = "__k-core__/graphics/target.png",
    flags = {"goes-to-main-inventory"},
    order = "a[targeter]",
    place_result = "targeter",
    stack_size = 1
  },
  {
    type = "decorative",
    name = "targeter",
    flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
    icon = "__k-core__/graphics/target.png",
    order = "a-b-a",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selectable_in_game = false,
    pictures =
    {
      {
        filename = "__k-core__/graphics/target.png",
        width = 32,
        height = 32,
      },
    }
  },
  {
    type = "selection-tool",
    name = "targeter-area",
    icon = "__k-core__/graphics/target.png",
    flags = {"goes-to-main-inventory"},
    order = "a[targeter-area]",
    stack_size = 1,
    stackable = false,
    selection_color = { r = 1, g = 1, b = 0 },
    selection_mode = {"any-entity"},
		selection_cursor_box_type = "copy",
    alt_selection_color = { r = 1, g = 1, b = 0 },
		alt_selection_mode = {"any-entity"},
    alt_selection_cursor_box_type = "copy"
  },
})