M = {}

-- Random choice.
function M.choice(t)
	return t[wesnoth.random(#t)]
end

-- Weighted random choice.
-- Pass table with items as keys and weights as values.
function M.choice_w(t)
	local total
	for k,v in pairs(t) do
		total = total + v
	end

	local index = wesnoth.random() * total

	for k,v in pairs(t) do
		index = index - v
		if index <= 0 then
			return k
		end
	end
end

return M
