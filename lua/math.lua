M = {}

-- Random choice.
function M.choice(t)
	return t[wesnoth.random(#t)]
end

-- Weighted random choice.
-- Pass table with items as {<item>, <weight>}.
function M.choice_w(t)
	local total = 0
	for _,v in ipairs(t) do
		total = total + v[2]
	end

	local index = wesnoth.random() * total

	for _,v in ipairs(t) do
		index = index - v[2]
		if index <= 0 then
			return v[1]
		end
	end
end

return M
