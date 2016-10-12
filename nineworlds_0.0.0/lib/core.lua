
function debug_out(data)
	if DEBUG then
    -- print to console
    if type(data) == "table" then
      print(serpent.block(data))
    else
      print(data)
    end
    -- print to screen
    if game and game.players and game.players[1] then
      if type(data) == "table" then
        game.players[1].print(serpent.block(data))
      else
        game.players[1].print(data)
      end
    end
	end
end

function arraylength(array)
	if array == nil then return 0 end
	count = 0
	for _,_ in ipairs(array) do
		count = count+1
	end
	return count
end

