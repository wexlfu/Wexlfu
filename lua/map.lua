M = {}

-- Put unit, find next vacant if needed.
-- x and y are optional if unit contains coordinates already.
function M.put_unit_vacant(unit, x, y)
	local x = x or unit.x
	local y = y or unit.y
	x,y = wesnoth.find_vacant_tile(x, y, unit)
	return wesnoth.put_unit(unit, x, y)
end

return M
