-- tiles
data:extend(
{
  {
    -- https://wiki.factorio.com/index.php?title=Types/AutoplaceSpecification
    type = "autoplace-control",
    name = "midgard",
    order = "b-e"
	}
})

-- for each "tile" "tree" and "decorative"
for _, _tile in pairs(data.raw.tile) do
  if _tile.autoplace and not _tile.autoplace.control then
    _tile.autoplace.control = "midgard"
  end
end
for _, _tree in pairs(data.raw.tree) do
  if _tree.autoplace and not _tree.autoplace.control then
    _tree.autoplace.control = "midgard"
  end
end
for _, _decorative in pairs(data.raw.decorative) do
  if _decorative.autoplace and not _decorative.autoplace.control then
    _decorative.autoplace.control = "midgard"
  end
end
