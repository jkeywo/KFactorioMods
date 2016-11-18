
local function create_targeter(data)
  local _name = "ability-"..data.name
  return {
    type = "item",
    name = _name,
    icon = data.sprite..".png",
    flags = {"goes-to-quickbar"},
    order = "a[".._name.."]",
    place_result = (data.type and data.type == "target" and _name) or nil,
    stack_size = 2
  }
end

local function create_selection_targeter(data)
  local _name = "ability-"..data.name
  return {
    type = "selection-tool",
    name = _name,
    icon = data.sprite..".png",
    flags = {"goes-to-quickbar"},
    order = "a[".._name.."]",
    stack_size = 2,
    selection_color = { r = 1, g = 1, b = 0 },
    selection_mode = data.mode or {"any-entity"},
		selection_cursor_box_type = data.box_type or "copy",
    alt_selection_color = { r = 1, g = 1, b = 0 },
		alt_selection_mode = data.alt_mode or {"any-entity"},
    alt_selection_cursor_box_type = data.alt_box_type or "copy"
  }
end

local function create_dummy_entity(data)
  local _name = "ability-"..data.name
  return {
    type = "decorative",
    name = _name,
    flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
    icon = data.sprite..".png",
    order = "a-b-a",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selectable_in_game = false,
    pictures =
    {
      {
        filename = data.sprite..".png",
        width = 32,
        height = 32,
      },
    }
  }
end

function register_ability( _data )
  if not _data.type or _data.type == "activate" then
    data:extend({
      create_targeter( _data )
    })
  elseif _data.type == "target" then
    data:extend({
      create_targeter( _data ),
      create_dummy_entity( _data )
    })
  elseif _data.type == "area" then
    data:extend({
      create_selection_targeter( _data )
    })
  end
end
