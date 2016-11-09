
function make_recipe(data)
  return {
      type = "recipe",
      name = data.name,
      enabled = true,
      energy_required = 4,
      ingredients =
      {
          {"grenade", 1},
      },
      result = data.name
  }
end
