-- pay and sprays are usually stored in garages,
-- henceforth we need to open them first
local garageDoors = {
	8, -- Idlewood Pay'n'Spray
	11, -- Temple Pay'n'Spray
	12, -- Santa Maria Beach Pay'n'Spray
}

addEventHandler("onResourceStart", resourceRoot,
	function()
		for _, door in ipairs(garageDoors) do
			setGarageOpen(door, true)
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for _, door in ipairs(garageDoors) do
			setGarageOpen(door, false)
		end
	end
)
