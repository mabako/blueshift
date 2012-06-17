local sql = exports.sql
local element = createElement("shop")

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value, sync )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

--------- [ Vehicle Shops ] ---------
local shops = 
{ 
	{
		{
		    { 562.9052, -1291.2724, 16.9763, 358 },
			{ 555.9052, -1291.2724, 16.9763, 358 },
			{ 548.9052, -1291.2724, 16.9763, 358 },
			{ 541.9052, -1291.2724, 16.9763, 358 },
			{ 534.9052, -1291.2724, 16.9763, 358 },
			{ 527.9052, -1291.2724, 16.9763, 358 },
			{ 520.9052, -1291.2724, 16.9763, 358 },
			{ 562.9052, -1281.2724, 16.9763, 358 },
			{ 555.9052, -1281.2724, 16.9763, 358 },
			{ 548.9052, -1281.2724, 16.9763, 358 },
			{ 541.9052, -1281.2724, 16.9763, 358 },
			{ 534.9052, -1281.2724, 16.9763, 358 },
			{ 562.9052, -1271.2724, 16.9763, 358 },
			{ 555.9052, -1271.2724, 16.9763, 358 },
			{ 548.9052, -1271.2724, 16.9763, 358 }
		},
		
		{
			{ "Buffalo", 51000 },
			{ "Phoenix", 75000 },
			{ "Banshee", 89000 },
			{ "Jester",  74000 },
			{ "Cheetah", 140000 },
			{ "Comet",   70000 },
			{ "Sultan",  45000 },
			{ "Elegy",   42000 },
			{ "Flash",   32000 },  
			{ "Uranus",  56000 },
			{ "Turismo", 200000 },
			{ "Infernus", 220000 },
			{ "Bullet", 130000 },
			{ "Super GT", 110000 },
			{ "ZR-350", 75000 },
			{ "Windsor", 43500 },
			{ "Feltzer", 61000 },
			{ "Euros", 48000 }
		}	
	},

	{
		{
			{ 1098.3671, -1775.6113, 13.1000, 90 },
			{ 1098.3671, -1769.6113, 13.1000, 90 },
			{ 1098.3671, -1763.6113, 13.1000, 90 },
			{ 1098.3671, -1757.6113, 13.1000, 90 },
			{ 1083.8710, -1775.5078, 13.1000, 270 },
			{ 1083.8710, -1769.5078, 13.1000, 270 },
			{ 1083.8710, -1763.5078, 13.1000, 270 },
			{ 1083.8710, -1757.5078, 13.1000, 270 },
			{ 1077.6035, -1775.7451, 13.1227, 90 },
			{ 1077.6035, -1769.7451, 13.1227, 90 },
			{ 1077.6035, -1763.7451, 13.1227, 90 },
			{ 1077.6035, -1757.7451, 13.1227, 90 },
			{ 1062.5878, -1775.6416, 13.1000, 270 },
			{ 1062.5878, -1769.6416, 13.1000, 270 },
			{ 1062.5878, -1763.6416, 13.1000, 270 },
			{ 1062.5878, -1757.6416, 13.1000, 270 },
			{ 1062.5878, -1751.6416, 13.1000, 270 },
			{ 1062.5878, -1745.6416, 13.1000, 270 },
			{ 1062.5878, -1739.6416, 13.1000, 270 }
		},
		
		{
			{ "Hustler", 18000 },
			{ "Blista Compact", 17000 },
			{ "Majestic", 11000 },
			{ "Bravura", 15000 },
			{ "Manana", 7000 },
			{ "Picador", 13000 },
			{ "Cadrona", 13000 },
			{ "Previon", 7000 },
			{ "Club", 9000 },
			{ "Stallion", 10000 },
			{ "Tampa", 7000 },
			{ "Fortune", 13000 },
			{ "Virgo", 15000 },
			{ "Admiral", 23000 },
			{ "Premier", 25000 },
			{ "Elegant", 22000 },
			{ "Primo", 18000 },
			{ "Emperor", 20000 },
			{ "Sentinel", 18500 },
			{ "Sunrise", 14000 },
			{ "Greenwood", 15000 },
			{ "Tahoma", 14000 },
			{ "Intruder", 16000 },
			{ "Vincent", 18000 },
			{ "Merit", 23000 },
			{ "Washington", 41000 },
			{ "Nebula", 22000 },
			{ "Willard", 15000 },
			{ "Walton", 6900 },
			{ "Clover", 5000 },
			{ "Sadler", 12000 },
			{ "Rumpo", 18000 },
			{ "Rancher", 23000 },
			{ "Moonbeam", 8000 },
			{ "Pony", 9000 },
			{ "Regina", 11500 },
			{ "Bobcat", 19000 },
			{ "Perennial", 10000 },
			{ "Camper", 27000 },
			{ "Burrito", 19000 },
			{ "Solair", 19500 },
			{ "Stratum", 31000 },
			{ "Yosemite", 34000 },
			{ "Patriot", 37000 },
			{ "Landstalker", 45000 },
			{ "Huntley", 29000 },
			{ "Mesa", 14500 },
			{ "Savanna", 18000 },
			{ "Blade", 17000 },
			{ "Broadway", 48000 },
			{ "Remington", 22000 },
			{ "Slamvan", 18000 },
			{ "Tornado", 16500 },
			{ "Voodoo", 7800 },
			{ "Oceanic", 14000 },
			{ "Glendale", 13000 },
			{ "Buccaneer", 14000 },
			{ "Esperanto", 13000 },
			{ "Hermes", 23000 }
		}
	},
	
	{
		{
			{ 2117.9296, -1131.3964, 24.8102, 267 },
			{ 2116.9296, -1137.3964, 24.8102, 267 },
			{ 2116.9296, -1143.3964, 24.8102, 267 },
			{ 2116.9296, -1149.3964, 24.8102, 267 },
			{ 2116.9296, -1155.3964, 24.8102, 267 },
			{ 2137.5888, -1131.5215, 25.2690, 85 },
			{ 2137.5888, -1137.5215, 25.2690, 85 },
			{ 2137.5888, -1143.5215, 25.2690, 85 },
			{ 2137.5888, -1149.5215, 25.2690, 85 }
		},
		
		{
			{ "BF-400", 16000 },
			{ "NRG-500", 60000 },
			{ "PCJ-600", 18000 },
			{ "Faggio", 1400 },
			{ "Pizzaboy", 1650 },
			{ "FCR-900", 12000 },
			{ "Sanchez", 5500 },
			{ "Freeway", 19500 },
			{ "Wayfarer", 1400 },
			{ "Quadbike", 3000 }
		}
	}
}


--------- [ Buy Vehicle ] ---------
addEventHandler("onVehicleStartEnter", root,
function( thePlayer )
	if (getElementParent(source) == element) then
		cancelEvent( )
		
		local name = getVehicleName(source)
		local price = 0
		for k, v in ipairs(shops) do 
			for i, j in ipairs(shops[k][2]) do
				if (j[1] == tostring(name)) then
				
					price = j[2]
				end
			end	
		end
		
		triggerClientEvent(thePlayer, "showVehicleBuyUI", thePlayer, source, price)
	end	
end)

--------- [ Re-order Vehicle ] ---------
function reorderVehicle( shop, x, y, z, rot )
	local data = { shop, x, y, z, rot }
	
	setTimer(function( )
		
		for m, n in ipairs(shops) do
			if ( m == tonumber( data[1] ) ) then
			
				local t = shops[m][2]
			
				local id = getVehicleModelFromName(tostring(t[math.random(1, #t)][1]))
				local x, y, z, rot = data[2], data[3], data[4], data[5]
				
				-- Spawn!
				local vehicle = createVehicle( id, x, y, z, 0, 0, rot )
				if isElement(vehicle) then
					
					setData(vehicle, "faction", -1, true)
					setData(vehicle, "dbid", 0, true)
					setData(vehicle, "owner", -1, true)
					setData(vehicle, "fuel", 100, true)
					setData(vehicle, "plate", "SHOP", true)
					setData(vehicle, "tinted", 0, true)
					setData(vehicle, "engine", 0, true)
					setData(vehicle, "enginebroke", 0, true)
					setData(vehicle, "impounded", 0, true)
					setData(vehicle, "handbrake", 0, true)
					
					setElementParent(vehicle, element)
					setElementFrozen(vehicle, true)
					break
				end	
			end	
		end
	end, 300000, 1)	
end
addEvent("reorderVehicle", true)
addEventHandler("reorderVehicle", root, reorderVehicle)
	
--------- [ Spawning Vehicles ] ---------
local spawnTimer = nil
function spawnShopVehicles( )
	
	local positions = { }
	positions[1] = { }
	positions[2] = { }
	positions[3] = { }
	
	for i, v in ipairs(shops) do 
		for k, j in ipairs(shops[i][1]) do 
			
			positions[i][k] = { j[1], j[2], j[3], j[4], j[5], j[6] }
		end
	end
	
	for m, n in ipairs(shops) do
		
		local t = shops[m][2]
		
		for j = 1, #positions[m] do
			
			local id = getVehicleModelFromName(tostring(t[math.random(1, #t)][1]))
			local x, y, z, rot = unpack(positions[m][j])
			
			-- Spawn!
			local vehicle = createVehicle( id, x, y, z, 0, 0, rot )
			if isElement(vehicle) then

				setData(vehicle, "faction", -1, true)
				setData(vehicle, "dbid", 0, true)
				setData(vehicle, "owner", -1, true)
				setData(vehicle, "fuel", 100, true)
				setData(vehicle, "plate", "SHOP", true)
				setData(vehicle, "tinted", 0, true)
				setData(vehicle, "engine", 0, true)
				setData(vehicle, "enginebroke", 0, true)
				setData(vehicle, "impounded", 0, true)
				setData(vehicle, "handbrake", 0, true)
				
				setElementParent(vehicle, element)
				setTimer(setElementFrozen, 1000, 1, vehicle, true)
			end
		end	
	end
end	
addEventHandler("onResourceStart", resourceRoot, spawnShopVehicles)

function startAllCycles( )
	for key, value in ipairs ( getElementsByType("vehicle") ) do
		local theVehicle = getVehicleNameFromModel( getElementModel( value ) )
		if ( theVehicle == "Bike" or theVehicle == "BMX" or theVehicle == "Mountain Bike" ) then
			
			setVehicleEngineState( value, true )
			setData( value, "engine", 1 )
		end
	end	
end
addCommandHandler("startcycle", startAllCycles)