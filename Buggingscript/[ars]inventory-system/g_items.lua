--[[
** IMPORTANT NOTE
	Do NOT insert any new item into the table from between,
	doing that will result in the change of the IDs of all
	other items, if you wish to insert a new item in between
	please define the key of the item first.

** Not so important notes
	To create a new food, add >>food = true, health = 20<< to the item line, see e.g. Hotdog. Health is the amount of health given.
	To create a new badge, add >>badge = "name of element data", color = {r, g, b}<< r,g,b are values from 0 to 255.
]]

-- Items table
g_items = 
{	
	-- Name, Type, Model, Rotation X, Rotation Y, Rotation Z, Elevation
	{"Vehicle Key", "Key", 1581, 270, 270, 0, 0},
	{"House Key", "Key", 1581, 270, 270, 0, 0},
	{"Cell Phone", "Generals", 330, 90, 90, 0, -0.05},
	{"Radio", "Generals", 1271, 0, 0, 0, -0.35},
	{"Mask", "Generals", 2386, 0, 0, 0, -0.1},
	{"Clothes", "Generals", 2386, 0, 0, 0, -0.1},
	{"Hotdog", "Generals", 2215, 205, 205, 0, -0.05, food = true, health = 20},
	{"Sandwich", "Generals", 2355, 205, 205, 0, -0.06, food = true, health = 20},
	{"Cookies", "Generals", 1271, 0, 0, 0, -0.35, food = true, health = 20},
	{"Water Bottle", "Generals", 1484, -15, 30, 0, -0.2, drink = true, health = 40, message = "some water"},
	{"Ice Cream", "Generals", 1271, 0, 0, 0, -0.35, food = true, health = 10},
	{"Choco Donut", "Generals", 2222, 0, 0, 0, -0.07, food = true, health = 20},
	{"Sweet Donut", "Generals", 2222, 0, 0, 0, -0.07, food = true, health = 20},
	{"Buster Pizza", "Generals", 2218, 205, 205, 0, -0.06, food = true, health = 20},
	{"Double D-Luxe Pizza", "Generals", 2219, 205, 205, 0, -0.06, food = true, health = 30},
	{"Full Rack Pizza", "Generals", 2220, 205, 205, 0, -0.06, food = true, health = 40},
	{"Cluckin' Little Meal", "Generals", 2215, 205, 205, 0, -0.06, food = true, health = 20},
	{"Cluckin' Big Meal", "Generals", 2216, 205, 205, 0, -0.06, food = true, health = 30},
	{"Cluckin' Huge Meal", "Generals", 2217, 205, 205, 0, -0.06, food = true, health = 40},
	{"Moo Kids Burger", "Generals", 2213, 205, 205, 0, -0.06, food = true, health = 20},
	{"Beef Tower Burger", "Generals", 2214, 205, 205, 0, -0.06, food = true, health = 30},
	{"Meat Stack Burger", "Generals", 2212, 205, 205, 0, -0.06, food = true, health = 40},
	{"Beer", "Generals", 1520, 0, 0, 0, -0.15, drink = true},
	{"Wine", "Generals", 1512, 0, 0, 0, -0.25, drink = true},
	{"Champagne", "Generals", 1669, 0, 0, 0, -0.15, drink = true},
	{"Coca Cola", "Generals", 2647, 0, 0, 0, -0.13, drink = true, health = 20},
	{"Generic Item", "Generals", 1271, 0, 0, 0, -0.35},
	{"SCUBA Equipment", "Generals", 1271, 0, 0, 0, -0.35},
	{"Boom Box", "Generals", 2102, 0, 0, 90, 0},
	{"Safe", "Generals", 2332, 0, 0, 0, -0.35 },
	{"Shelf", "Generals", 3761, 0, 0, 90, 1.95 },
	{"LSPD Badge", "Generals", 1581, 270, 270, 0, 0, badge = "LSPDbadge", color = {0, 100, 255} },
	{"LSFD Badge", "Generals", 1581, 270, 270, 0, 0, badge = "LSFDbadge", color = {175, 50, 50} },
	{"SANE ID", "Generals", 1581, 270, 270, 0, 0, badge = "SANEbadge", color = {109, 61, 150} },
	{"LSVS ID", "Generals", 1581, 270, 270, 0, 0, badge = "LSVSbadge", color = {232, 98, 9} },
	{"Marijuana", "Generals", 1577, 0, 0, 0, 0 },
	{"Lysergic Acid", "Generals", 1575, 0, 0, 0, 0},
	{"Cocaine", "Generals", 1576, 0, 0, 0, 0},
	{"PCP Hydrochloride", "Generals", 1578, 0, 0, 0, 0},
	{"Heroin", "Generals", 1579, 0, 0, 0, 0},
	{"Subutex", "Generals", 1580, 0, 0, 0, 0},
	{"Red Bandana", "Generals", 1271, 0, 0, 0, -0.35},
	{"Blue Bandana", "Generals", 1271, 0, 0, 0, -0.35},
	{"Yellow Bandana", "Generals", 1271, 0, 0, 0, -0.35},
	{"Green Bandana", "Generals", 1271, 0, 0, 0, -0.35},
	{"White Bandana", "Generals", 1271, 0, 0, 0, -0.35},
	{"Black Bandana", "Generals", 1271, 0, 0, 0, -0.35},
	{"SCBA Equipment", "Generals", 1271, 0, 0, 0, -0.35},
	{"Motorcycle Helmet", "Generals", 1271, 0, 0, 0, -0.35},
	{"Gas Mask", "Generals", 1271, 0, 0, 0, -0.35},
	{"Lighter", "Generals", 1271, 0, 0, 0, -0.35},
	{"Cigarette", "Generals", 1271, 0, 0, 0, -0.35},
	{"Card Deck", "Generals", 1271, 0, 0, 0, -0.35},
	{"FBI Badge", "Generals", 1581, 270, 270, 0, 0, badge = "FBIbadge", color = {30, 90, 124}},
}

function getItemDetails( item )
	if (item == tostring(item)) then -- Item name was given
		
		local itemModel, itemID, rx, ry, rz, elevation = false, false, false, false, false, false
		for i, v in ipairs(g_items) do
			if tostring(v[1]) == item then
				
				itemModel, itemID, rx, ry, rz, elevation = v[3], i, v[4], v[5], v[6], v[7]
				break
			end
		end
			
		return itemModel, itemID, rx, ry, rz, elevation
	elseif (item == tonumber(item)) then -- Item id was given
		
		local itemModel, itemName, rx, ry, rz, elevation = false, false, false, false, false, false
		for i, v in ipairs(g_items) do
			if tonumber(i) == item then
				
				itemModel, itemName, rx, ry, rz, elevation = v[3], v[1], v[4], v[5], v[6], v[7]
				break
			end
		end
			
		return itemModel, itemName, rx, ry, rz, elevation
	end
end

-- load all badge data, it'll be a table like badges["FBIbadge"] = {color = {r, g, b}, itemID = 3}
local badges = {}
for k, v in ipairs(g_items) do
	if v.badge then
		badges[v.badge] = {color = v.color, itemID = k}
	end
end

function getBadges()
	return badges
end