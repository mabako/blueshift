local sql = exports.sql
local handbrake = 0

local bike = { ["BMX"] = true, ["Bike"] = true, ["Mountain Bike"] = true }
local engineBike = { ["Quadbike"] = true, ["BF-400"] = true, ["NRG-500"] = true, ["PCJ-600"] = true, ["Faggio"] = true, ["Pizza Boy"] = true, ["FCR-900"] = true, ["Sanchez"] = true, ["Freeway"] = true, ["Wayfarer"] = true }

local emergencyVehicle = 
{ [416] = true, [433] = true, [427] = true, [490] = true, [528] = true, [407] = true, [544] = true, 
  [523] = true, [598] = true, [596] = true, [597] = true, [599] = true, [601] = true 
}

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

-- Generate a number plate according to city name
local regionCodes = { ["Los Santos"]="LS", ["Las Venturas"]="LV", ["San Fierro"]="SF" }
function generateRandomPlate( thePlayer )
	local zone = getElementZoneName(thePlayer, true)
	local region = regionCodes[tostring(zone)]
	if not region then region = "SA" end
	local code = math.random(0, 9) .."".. math.random(0, 9) .."".. math.random(0, 9) .."".. math.random(0, 9) 
	
	local plate = region .." ".. code
	return plate 
end	

-- /makeveh
-- /makecivveh
-- /veh
-- /fixveh
-- /fixvehs
-- /refillveh
-- /setcarhp 
-- /nearbyvehs
-- /unflip
-- /tpcar
-- /tptocar
-- /addupgrade
-- /fuelveh
-- /delveh
-- /setvehcolor
-- /setvehcustomcolor
-- /respawnvehs
-- /respawnveh

--------- [ Admin Commands ] ---------
local alphabets = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "-"}

-- /makeveh
function makeVehicle( thePlayer, commandName, partialPlayerName, faction, tinted, job, color1, color2, ... )
	if exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (...) and (partialPlayerName) then
			
			local name = table.concat({...}, " ")
			local model = nil
			
			for i = 1, #alphabets do
				if ( string.find( name, tostring( string.lower( alphabets[i] ) ) ) ) then
					
					local find = tonumber( getVehicleModelFromName( tostring( name ) ) )
					if ( not find ) then
						outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
						return
					else
						model = find
						break
					end	
				end
			end
			
			if ( model == nil ) then
				model = tonumber( name )
			end
			
			local id = model
			
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				if not (faction) then faction = -1 end
				if not (tinted) then tinted = 0 end
				if not (job) then job = -1 end
				if not (color1) then color1 = math.random(0, 126) end
				if not (color2) then color2 = math.random(0, 126) end
				
				local x, y, z = getElementPosition(foundPlayer)
				local rot = getPedRotation(foundPlayer)
				local dim = getElementDimension(foundPlayer)
				local int = getElementInterior(foundPlayer)
				local owner = getData(foundPlayer, "dbid")
				local plate = generateRandomPlate(foundPlayer)
				
				x = x + ( ( math.cos ( math.rad ( rot ) ) ) * 3 )
				y = y + ( ( math.sin ( math.rad ( rot ) ) ) * 3 )
				local vehicle = createVehicle( id, x, y, z, 0, 0, rot, tostring(plate) )
				if (vehicle) then
					
					local insert = sql:query("INSERT INTO vehicles SET model=".. sql:escape_string(id) ..", currx=".. sql:escape_string(x) ..", x=".. sql:escape_string(x) ..", curry=".. sql:escape_string(y) ..", y=".. sql:escape_string(y) ..", currz=".. sql:escape_string(z) ..", z=".. sql:escape_string(z) ..", currrotx='0', rotx='0', currroty='0', roty='0', currrotz=".. sql:escape_string(rot) ..", rotz=".. sql:escape_string(rot) ..", currdimension=".. sql:escape_string(dim) ..", dimension=".. sql:escape_string(dim) ..", currinterior=".. sql:escape_string(int) ..", interior=".. sql:escape_string(int) ..", upgrades='', wheelStates='', panelStates='', doorStates='', color1=".. sql:escape_string(color1) ..", color2=".. sql:escape_string(color2) ..", faction=".. sql:escape_string(faction) ..", owner=".. sql:escape_string(owner) ..", job=".. sql:escape_string(job) ..", plate='".. sql:escape_string(plate) .."', tinted=".. sql:escape_string(tinted) ..", items='', itemvalues=''") 
					if (insert) then
						local insertid = sql:insert_id()
						
						setVehicleColor(vehicle, tonumber(color1), tonumber(color2), 0, 0)
						
						engineVal, engine = 0, false
						if ( bike[getVehicleName( vehicle )] ) then
							engineVal, engine = 1, true
						end
				
						setData(vehicle, "faction", tonumber(faction), true)
						setData(vehicle, "dbid", tonumber(insertid), true)
						setData(vehicle, "owner", tonumber(owner), true)
						setData(vehicle, "fuel", 151, true)
						setData(vehicle, "plate", tostring(plate), true)
						setData(vehicle, "tinted", tonumber(tinted), true)
						setData(vehicle, "engine", engineVal, true)
						setData(vehicle, "enginebroke", 0, true)
						setData(vehicle, "impounded", 0, true)
						setData(vehicle, "handbrake", 0, true)
						setData(vehicle, "custom_color", 0, true)
						setData(vehicle, "job", tonumber(job), true)
						
						-- Items
						setData(vehicle, "items", "", true) 
						setData(vehicle, "values", "", true) 
						
						setVehicleEngineState(vehicle, engine)
						
						-- Journey
						if ( id == 508 ) then
							if ( owner > 0 ) and ( tonumber( faction ) <= 0 ) then
								exports['[ars]interior-system']:createVehicleInterior( vehicle )
							else
								outputChatBox("An interior is only available for a owned Journey.", thePlayer, 255, 0, 0)
							end	
						end
				
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." created ".. getVehicleNameFromModel(id) .." with ID ".. insertid ..".")
						outputChatBox(getVehicleNameFromModel(id) .." created with ID ".. insertid ..".", thePlayer, 212, 156, 49)
					else
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end

					sql:free_result(insert)
				else
					outputChatBox("Invalid Vehicle ID", thePlayer, 255, 0, 0)
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Owner Name/ID] [Faction ID] [Tinted ( 1/0)] [Job ID] [Color 1] [Color 2] [Vehicle Name /ID] ", thePlayer, 212, 156, 14)
		end	
	end	
end
addCommandHandler("makeveh", makeVehicle, false, false)

-- /makecivveh
function makeCivVehicle( thePlayer, commandName, job, ... )
	if exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (...) then
			
			local name = table.concat({...}, " ")
			local model = nil
			
			for i = 1, #alphabets do
				if ( string.find( name, tostring( string.lower( alphabets[i] ) ) ) ) then
					
					local find = tonumber( getVehicleModelFromName( tostring( name ) ) )
					if ( not find ) then
						outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
						return
					else
						model = find
						break
					end	
				end
			end
			
			if ( model == nil ) then
				model = tonumber( name )
			end
			
			local id = model
			
			local x, y, z = getElementPosition(thePlayer)
			local rot = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			
			if not (job) then job = -1 end
			local owner = -1
			local color1, color2 = math.random(0, 126), math.random(0, 126)
			local plate = generateRandomPlate(thePlayer)
				
			x = x + ( ( math.cos ( math.rad ( rot ) ) ) * 3 )
			y = y + ( ( math.sin ( math.rad ( rot ) ) ) * 3 )
			
			local vehicle = createVehicle( id, x, y, z, 0, 0, rot, tostring(plate) )
			if (vehicle) then
			
				local insert = sql:query("INSERT INTO vehicles SET model=".. sql:escape_string(id) ..", currx=".. sql:escape_string(x) ..", x=".. sql:escape_string(x) ..", curry=".. sql:escape_string(y) ..", y=".. sql:escape_string(y) ..", currz=".. sql:escape_string(z) ..", z=".. sql:escape_string(z) ..", currrotx='0', rotx='0', currroty='0', roty='0', currrotz=".. sql:escape_string(rot) ..", rotz=".. sql:escape_string(rot) ..", currdimension=".. sql:escape_string(dim) ..", dimension=".. sql:escape_string(dim) ..", currinterior=".. sql:escape_string(int) ..", interior=".. sql:escape_string(int) ..", upgrades='', wheelStates='', panelStates='', doorStates='', color1=".. sql:escape_string(color1) ..", color2=".. sql:escape_string(color2) ..", owner=".. sql:escape_string(owner) ..", job=".. sql:escape_string(job) ..", plate='".. sql:escape_string(plate) .."', items='', itemvalues=''") 
				if (insert) then
					local insertid = sql:insert_id()
					
					setVehicleColor(vehicle, tonumber(color1), tonumber(color2), 0, 0)
					
					engineVal, engine = 0, false
					if ( bike[getVehicleName( vehicle )] ) then
						engineVal, engine = 1, true
					end

					setData(vehicle, "faction", -1, true)
					setData(vehicle, "dbid", tonumber(insertid), true)
					setData(vehicle, "owner", -1, true)
					setData(vehicle, "fuel", 151, true)
					setData(vehicle, "plate", tostring(plate), true)
					setData(vehicle, "tinted", 0, true)
					setData(vehicle, "engine", engineVal, true)
					setData(vehicle, "enginebroke", 0, true)
					setData(vehicle, "impounded", 0, true)
					setData(vehicle, "handbrake", 0, true)
					setData(vehicle, "custom_color", 0, true)
					setData(vehicle, "job", tonumber(job), true)
					
					-- Items
					setData(vehicle, "items", "", true) 
					setData(vehicle, "values", "", true) 
					
					setVehicleEngineState(vehicle, engine)
					
					-- Journey
					if ( id == 508 ) then
						outputChatBox("No interior is available for a civilian vehicle.", thePlayer, 255, 0, 0)
					end
					
					exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." created ".. getVehicleNameFromModel(id) .." with ID ".. insertid ..".")
					outputChatBox(getVehicleNameFromModel(id) .." created with ID ".. insertid ..".", thePlayer, 212, 156, 49)
				else
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end	
				
				sql:free_result(insert)
			else
				outputChatBox("Invalid Vehicle ID", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Job ID (-1)] [Vehicle Name]", thePlayer, 212, 156, 14)
		end	
	end	
end
addCommandHandler("makecivveh", makeCivVehicle, false, false)

-- /veh
local tempVehicleCount = 0
function makeTemporaryVehicle( thePlayer, commandName, ... )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (...) then
			
			local name = table.concat({...}, " ")
			local model = nil
			
			for i = 1, #alphabets do
				if ( string.find( name, tostring( string.lower( alphabets[i] ) ) ) ) then
					
					local find = tonumber( getVehicleModelFromName( tostring( name ) ) )
					if ( not find ) then
						outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
						return
					else
						model = find
						break
					end	
				end
			end
			
			if ( model == nil ) then
				model = tonumber( name )
			end
			
			local id = model
			
			local x, y, z = getElementPosition(thePlayer)
			local rot = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			
			local dbid = tempVehicleCount+1
			local plate = generateRandomPlate(thePlayer)
			
			x = x + ( ( math.cos ( math.rad ( rot ) ) ) * 3 )
			y = y + ( ( math.sin ( math.rad ( rot ) ) ) * 3 )
			
			local vehicle = createVehicle( id, x, y, z, 0, 0, rot, tostring(plate) )
			if (vehicle) then
				
				engineVal, engine = 0, false
				if ( bike[getVehicleName( vehicle )] ) then
					engineVal, engine = 1, true
				end
				
				setData(vehicle, "faction", -1, true)
				setData(vehicle, "dbid", -dbid, true)
				setData(vehicle, "owner", -1, true)
				setData(vehicle, "fuel", 151, true)
				setData(vehicle, "plate", tostring(plate), true)
				setData(vehicle, "tinted", 0, true)
				setData(vehicle, "engine", engineVal, true)
				setData(vehicle, "enginebroke", 0, true)
				setData(vehicle, "impounded", 0, true)
				setData(vehicle, "handbrake", 0, true)
				setData(vehicle, "custom_color", 0, true)
				setData(vehicle, "job", -1, true)
				
				setVehicleEngineState(vehicle, engine)
				
				-- Journey
				if ( id == 508 ) then
					outputChatBox("No interior is available for a temporary vehicle.", thePlayer, 255, 0, 0)
				end
			
				tempVehicleCount = tempVehicleCount + 1
				
				exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." created ".. getVehicleNameFromModel(id) .." with ID ".. -dbid ..".")
				outputChatBox(getVehicleNameFromModel(id) .." created with ID ".. -dbid ..".", thePlayer, 212, 156, 49)
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Vehicle Name / ID]", thePlayer, 212, 156, 49)
		end
	end
end	
addCommandHandler("veh", makeTemporaryVehicle, false, false)

-- /fixveh		
function fixVeh( thePlayer, commandName, partialPlayerName)
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if (partialPlayerName) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local vehicle = getPedOccupiedVehicle(foundPlayer)
				if isElement(vehicle) then
					
					local success = fixVehicle(vehicle)
					if success then
						outputChatBox("You fixed ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.", thePlayer, 212, 156, 49)
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." fixed ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.")
					else
						outputChatBox("Failed to fix ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.", thePlayer, 255, 0, 0)
					end	
				else
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name/ID ]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("fixveh", fixVeh, false, false)

-- /fixvehs
function fixVehicles( thePlayer, commandName )
	if exports['[ars]global']:isPlayerModerator(thePlayer) then
		
		for key, theVehicle in ipairs ( getElementsByType("vehicle") ) do
			fixVehicle( theVehicle )
		end

		outputChatBox("~-~-~-~ All Vehicles Repaired by ".. getPlayerName(thePlayer):gsub("_", " ") .." ~-~-~-~", root, 212, 156, 49)
	end
end
addCommandHandler("fixvehs", fixVehicles, false, false)

-- /refuelvehs
function refuelVehicles( thePlayer, commandName )
	if exports['[ars]global']:isPlayerModerator(thePlayer) then
		
		for key, theVehicle in ipairs ( getElementsByType("vehicle") ) do
			setData(theVehicle, "fuel", 151, true)
		end

		outputChatBox("~-~-~-~ All Vehicles Re-fueled by ".. getPlayerName(thePlayer):gsub("_", " ") .." ~-~-~-~", root, 212, 156, 49)
	end
end
addCommandHandler("refuelvehs", refuelVehicles, false, false)

-- /refuelveh
function refeulVehicle( thePlayer, commandName, partialPlayerName)
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if (partialPlayerName) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local vehicle = getPedOccupiedVehicle(foundPlayer)
				if isElement(vehicle) then
					
					setData(vehicle, "fuel", 151, true)
					outputChatBox("You refueled ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.", thePlayer, 212, 156, 49)
					
					exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." refilled ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.")
				else
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("refuelveh", refeulVehicle, false, false)
	
-- /setcarhp
function setVehHealth( thePlayer, commandName, partialPlayerName, health)
	if exports['[ars]global']:isPlayerModerator(thePlayer) then
		if (partialPlayerName) and (health) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local vehicle = getPedOccupiedVehicle(foundPlayer)
				if isElement(vehicle) then
					
					local health = tonumber(health)
					if health > 1000 then
						health = 1000
					elseif health < 0 then
						health = 0
					end
					
					local success = setElementHealth(vehicle, tonumber(health))
					if success then
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle's health set to ".. tostring(health) ..".", thePlayer, 212, 156, 49)
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle HP to ".. tostring(health) ..".")
					else
						outputChatBox("Failed to set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle's health.", thePlayer, 255, 0, 0)
					end	
				else
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name/ID ] [ Health ]", thePlayer, 212, 156, 49)
		end
	end	
end	
addCommandHandler("setcarhp", setVehHealth, false, false)

-- /nearbyvehs
function nearbyVehicles( thePlayer, commandName )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		outputChatBox("~-~-~-~-~-~ Nearby Vehicles ~-~-~-~-~-~", thePlayer, 212, 156, 49)

		local count = 0
		for key, theVehicle in ipairs( getElementsByType("vehicle") ) do
			
			local x, y, z = getElementPosition( thePlayer )
			local vx, vy, vz = getElementPosition( theVehicle )
			
			if ( getDistanceBetweenPoints3D( x, y, z, vx, vy, vz ) <= 20 ) then
				
				count = count + 1
				
				outputChatBox("#".. count .." - ID: ".. tostring( getData( theVehicle, "dbid") ) ..", Name: ".. getVehicleName( theVehicle ) ..", Owner: ".. getVehicleOwner( tostring( getData( theVehicle, "owner" ) ) ), thePlayer, 212, 156, 49)
			end
		end
			
		if (count == 0) then
			outputChatBox("Couldn't find any vehicles nearby you.", thePlayer, 255, 0, 0)
		end	
	end
end
addCommandHandler("nearbyvehs", nearbyVehicles, false, false)

-- /unflip
function unflipVehicle( thePlayer, commandName, partialPlayerName )
	if ( getData(thePlayer, "faction") == 3 ) or ( exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then
	
		if (partialPlayerName) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local vehicle = getPedOccupiedVehicle(foundPlayer)
				if isElement(vehicle) then
					
					local rotx, roty, rotz = getVehicleRotation(vehicle)
					
					local success = setVehicleRotation(vehicle, 0, roty, rotz)
					if success then
						outputChatBox("You unflipped ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.", thePlayer, 212, 156, 49)
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." unflipped ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.")
					else
						outputChatBox("Failed to unflip ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.", thePlayer, 255, 0, 0)
					end	
				else
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		else
			
			local vehicle = getPedOccupiedVehicle(thePlayer)
			if isElement(vehicle) then
				
				local rotx, roty, rotz = getVehicleRotation(vehicle)
						
				local success = setVehicleRotation(vehicle, 0, roty, rotz)
				if success then
					outputChatBox("You unflipped your vehicle.", thePlayer, 212, 156, 49)
				else
					outputChatBox("Failed to unflip your vehicle.", thePlayer, 255, 0, 0)
				end	
			else
				outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
			end	
		end
	end
end
addCommandHandler("unflip", unflipVehicle, false, false)	
			
-- /tpcar
function teleportVehicle( thePlayer, commandName, id )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (id) then
			local id = tonumber(id)
			
			local theVehicle = false
			for i, vehicle in ipairs ( getElementsByType("vehicle") ) do
				
				local dbid = getData(vehicle, "dbid")
				if tonumber(dbid) == id then
					
					theVehicle = vehicle
					break
				end
			end
			
			if (theVehicle) then
				local int = getElementInterior(thePlayer)
				local dim = getElementDimension(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local rot = getPedRotation(thePlayer)
				
				x = x + ( ( math.cos ( math.rad ( rot ) ) ) * 3 )
				y = y + ( ( math.sin ( math.rad ( rot ) ) ) * 3 )
				
				setElementInterior(theVehicle, int)
				setElementDimension(theVehicle, dim)
				setElementPosition(theVehicle, x, y, z)
				setElementRotation(theVehicle, 0, 0, rot)
				
				exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." teleported vehicle ID ".. id .." to them.")
				outputChatBox("You teleported vehicle ID ".. id .." to you.", thePlayer, 212, 156, 49)
			else
				outputChatBox("Invalid vehicle ID.", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Vehicle ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tpcar", teleportVehicle, false, false)

-- /tptocar
function teleportToVehicle( thePlayer, commandName, id )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (id) then
			local id = tonumber(id)
			
			local theVehicle = false
			for i, vehicle in ipairs ( getElementsByType("vehicle") ) do
				
				local dbid = getData(vehicle, "dbid")
				if tonumber(dbid) == id then
					
					theVehicle = vehicle
					break
				end
			end
			
			if (theVehicle) then
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				local rotx, roty, rotz = getElementRotation(theVehicle)
				
				x = x + ( ( math.cos ( math.rad ( rotz ) ) ) * 3 )
				y = y + ( ( math.sin ( math.rad ( rotz ) ) ) * 3 )
				
				setElementInterior(thePlayer, int)
				setElementDimension(thePlayer, dim)
				setElementPosition(thePlayer, x, y, z)
				setPedRotation(thePlayer, rotz)
				
				exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." teleported to vehicle ID ".. id ..".")
				outputChatBox("You teleported to vehicle ID ".. id ..".", thePlayer, 212, 156, 14)
			else
				outputChatBox("Invalid vehicle ID.", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Vehicle ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tptocar", teleportToVehicle, false, false)
	
-- /addupgrade
function addUpgrade( thePlayer, commandName, partialPlayerName, upgradeID )
	if exports['[ars]global']:isPlayerModerator(thePlayer) then	
		
		if (partialPlayerName) and (upgradeID) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local vehicle = getPedOccupiedVehicle(foundPlayer)
				if isElement(vehicle) then
					
					local success = addVehicleUpgrade( vehicle, upgradeID )
					if success then
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." upgraded ".. getVehicleUpgradeSlotName(upgradeID) .."' to ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.")
						outputChatBox(getVehicleUpgradeSlotName(upgradeID) .." added to ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.", thePlayer, 212, 156, 49)
					else
						outputChatBox("Failed to add an upgrade to ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle.", thePlayer, 255, 0, 0)
					end	
				else
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Upgrade ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("addupgrade", addUpgrade, false, false) 	
			
-- /delveh
function deleteVehicle( thePlayer, commandName, id )
	local adminLevel = tonumber( getData( thePlayer, "admin" ) )
	if ( adminLevel == 0 ) then
		
		return
	else	
		if (id) then
			local id = tonumber(id)
			
			local theVehicle = false
			for i, vehicle in ipairs ( getElementsByType("vehicle") ) do
				
				local dbid = getData(vehicle, "dbid")
				if tonumber(dbid) == id then
					
					theVehicle = vehicle
					break
				end
			end
			
			if (theVehicle) then
				
				if (id < 0) then
					
					destroyElement(theVehicle)
					theVehicle = nil
				elseif (id > 0) then
					if ( adminLevel >= 4 ) then
					
						local delete = sql:query("DELETE FROM vehicles WHERE id=".. sql:escape_string(id) .."")
						if (delete) then
							
							-- Journey
							if ( getElementModel(theVehicle) == 508 ) then
								for key, value in ipairs ( getElementsByType("marker") ) do
									if ( tonumber( getData(value, "dbid") ) == -id ) then
										
										destroyElement(value)
									end
								end
							end
							
							destroyElement(theVehicle)
							theVehicle = nil
						else
							outputDebugString("MySQL Error: Vehicle deletion failed!", 1)
						end
						
						sql:free_result(delete)
					else
						outputChatBox("You cannot delete a permanent vehicle.", thePlayer, 255, 0, 0)
					end	
				end
				
				exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." deleted vehicle with ID ".. id ..".")
				outputChatBox("Vehicle ID ".. id .." deleted.", thePlayer, 212, 156, 49)
			else
				outputChatBox("Invalid vehicle ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Vehicle ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)
	
-- /setvehcolor
function setVehColor( thePlayer, commandName, partialPlayerName, color1, color2 )	
	if exports['[ars]global']:isPlayerModerator(thePlayer) then	
		
		if (partialPlayerName) and (color1) and (color2) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local color1 = tonumber(color1)
				local color2 = tonumber(color2)
				
				local vehicle = getPedOccupiedVehicle(foundPlayer)
				if isElement(vehicle) then
					local dbid = tonumber(getData(vehicle, "dbid"))
					
					local success = setVehicleColor(vehicle, color1, color2, 0, 0)
					if (success) then
						
						local update = sql:query("UPDATE vehicles SET `color1`=".. sql:escape_string(color1) ..", `color2`=".. sql:escape_string(color2) ..", `custom_colors`='' WHERE `id`=".. sql:escape_string(dbid) .."")
						if (update) then
							
							setData( vehicle, "custom_color", 0, true )
							outputChatBox("Updated ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle color.", thePlayer, 212, 156, 49)
						end

						sql:free_result(update)
					else
						outputChatBox("Failed to update ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle color.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID] [Color 1] [Color 2]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setvehcolor", setVehColor, false, false)

-- /setvehcustomcolor
function setVehicleCustomColor( thePlayer, commandName, partialPlayerName, red1, green1, blue1, red2, green2, blue2 )
	if exports['[ars]global']:isPlayerModerator(thePlayer) then	
		
		if (partialPlayerName) and (red1) and (green1) and (blue1) and (red2) and (green2) and (blue2) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local red1 = tonumber(red1)
				local green1 = tonumber(green1)
				local blue1 = tonumber(blue1)
				local red2 = tonumber(red2)
				local green2 = tonumber(green2)
				local blue2 = tonumber(blue2)
				
				local vehicle = getPedOccupiedVehicle(foundPlayer)
				if isElement(vehicle) then
					local dbid = tonumber(getData(vehicle, "dbid"))
					
					local success = setVehicleColor(vehicle, red1, green1, blue1, red2, green2, blue2 )
					if (success) then
						
						local strng = red1 ..",".. green1 ..",".. blue1 ..",".. red2 ..",".. green2 ..",".. blue2
						if ( strng ) then
							
							local update = sql:query("UPDATE vehicles SET `color1`='', `color2`='', `custom_colors`='".. sql:escape_string(strng) .."' WHERE `id`=".. sql:escape_string(dbid) .."")
							if (update) then
							
								outputChatBox("Updated ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle color.", thePlayer, 212, 156, 49)
								setData( vehicle, "custom_color", 1, true )
							else
								outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
							end	
							
							sql:free_result(update)
						end	
					else
						outputChatBox("Failed to update ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s vehicle color.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in a vehicle.", thePlayer, 255, 0, 0)
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID] [Red 1] [Green 1] [Blue 1] [Red 2] [Green 2] [Blue 2]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setvehcustomcolor", setVehicleCustomColor, false, false)

-- /respawnvehs
local vehRespawnTimer = false 
function respawnVehicles( thePlayer, commandName, timer )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then	
		
		if (vehRespawnTimer) then
			
			outputChatBox("A vehicle respawn is already underway!", thePlayer, 255, 0, 0)
			return
		else	
			if (timer == nil) then
				timer = 30
			else
				timer = tonumber(timer)
			end
			
			if ( timer <= 0 ) then
				outputChatBox("Invalid time entered!", thePlayer, 255, 0, 0)
				return
			else	
				vehRespawnTimer = true
			end
			
			outputChatBox("~-~-~-~ All vehicles will be respawned in ".. timer .." seconds! ~-~-~-~", root, 212, 156, 49)
			
			setTimer(function( )
			
				for index, vehicle in pairs ( getElementsByType("vehicle") ) do
					
					local isOccupant = false
					
					local seat = 0
					while seat <= 3 do
						local occupant = getVehicleOccupant(vehicle)
						if (occupant) then
							
							isOccupant = true
							break
						end	
						
						seat = seat + 1
					end	
					
					if (isOccupant == false) then
						
						local dbid = getData(vehicle, "dbid")
						if ( dbid > 0 ) then
							
							local isTrailerAttached = false
							if ( getElementModel( vehicle ) == 584 ) then -- Trailer
								
								isTrailerAttached = exports['[ars]job-system']:isTrailerAttached( vehicle )
							end
							
							local hasTrailerAttached = false
							if ( getElementModel( vehicle ) == 514 ) then -- Tanker
								
								hasTrailerAttached = exports['[ars]job-system']:hasTrailerAttached( vehicle )
							end
							
							if ( not hasTrailerAttached ) and ( not isTrailerAttached ) then 
								
								local row = sql:query_fetch_assoc("SELECT x, y, z, rotx, roty, rotz, dimension, interior FROM vehicles WHERE id =".. sql:escape_string(tonumber(dbid)) .."")
								if (row) then
								
									local x = row['x']
									local y = row['y']
									local z = row['z']
									local rotx = row['rotx']
									local roty = row['roty']
									local rotz = row['rotz']
									local dim = row['dimension'] 
									local int = row['interior']
								
									setElementDimension(vehicle, dim)
									setElementInterior(vehicle, int)
									
									setElementPosition(vehicle, x, y, z)
									setElementRotation(vehicle, rotx, roty, rotz)
								end
							end	
						elseif ( dbid < 0 ) then
							destroyElement( vehicle )
						end	
					end	
				end
			
				outputChatBox("~-~-~-~-~-~-~-~ All vehicles respawned! ~-~-~-~-~-~-~-~", root, 212, 156, 49)
				
				tempVehicleCount = 0
				vehRespawnTimer = false
				
			end, timer*1000, 1)
		end	
	end	
end
addCommandHandler("respawnvehs", respawnVehicles, false, false)

-- /respawncivvehs
local civVehRespawnTimer = false
function respawnCivVehicles( thePlayer, commandName, timer )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then	
		
		if (civVehRespawnTimer) then
			
			outputChatBox("A civilian vehicle respawn is already underway!", thePlayer, 255, 0, 0)
			return
		else	
			
			if (timer == nil) then
				timer = 30
			else
				timer = tonumber(timer)
			end
			
			if ( timer <= 0 ) then
				outputChatBox("Invalid time entered!", thePlayer, 255, 0, 0)
				return
			else
				civVehRespawnTimer = true
			end
			
			outputChatBox("~-~-~-~ All civilian vehicles will be respawned in ".. timer .." seconds! ~-~-~-~", root, 212, 156, 49)
			
			setTimer(function( )
			
				for index, vehicle in pairs ( getElementsByType("vehicle") ) do
					
					local isOccupant = false
					
					local seat = 0
					while seat <= 3 do
						local occupant = getVehicleOccupant(vehicle)
						if (occupant) then
							
							isOccupant = true
							break
						end	
						
						seat = seat + 1
					end	
					
					if (isOccupant == false) then
						
						local dbid = tonumber( getData(vehicle, "dbid") )
						local owner = tonumber( getData(vehicle, "owner") )
						
						if ( owner == -1 ) then
							
							local isTrailerAttached = false
							if ( getElementModel( vehicle ) == 584 ) then -- Trailer
								
								isTrailerAttached = exports['[ars]job-system']:isTrailerAttached( vehicle )
							end
							
							local hasTrailerAttached = false
							if ( getElementModel( vehicle ) == 514 ) then -- Tanker
								
								hasTrailerAttached = exports['[ars]job-system']:hasTrailerAttached( vehicle )
							end
							
							if ( not hasTrailerAttached ) and ( not isTrailerAttached ) then 
							
								local row = sql:query_fetch_assoc("SELECT x, y, z, rotx, roty, rotz, dimension, interior FROM vehicles WHERE id =".. sql:escape_string(tonumber(dbid)) .."")
								if (row) then
								
									local x = row['x']
									local y = row['y']
									local z = row['z']
									local rotx = row['rotx']
									local roty = row['roty']
									local rotz = row['rotz']
									local dim = row['dimension'] 
									local int = row['interior']
								
									setElementDimension(vehicle, dim)
									setElementInterior(vehicle, int)
									
									setElementPosition(vehicle, x, y, z)
									setElementRotation(vehicle, rotx, roty, rotz)
								end
							end	
						elseif ( dbid < 0 ) then
							destroyElement( vehicle )
						end	
					end	
				end
			
				outputChatBox("~-~-~-~-~-~-~-~ All civilian vehicles respawned! ~-~-~-~-~-~-~-~", root, 212, 156, 49)
				
				tempVehicleCount = 0
				civVehRespawnTimer = false
				
			end, timer*1000, 1)
		end	
	end	
end
addCommandHandler("respawncivvehs", respawnCivVehicles, false, false)

-- /respawnveh
function respawnVeh( thePlayer, commandName, id )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then	
	
		if (id) then
			local id = tonumber(id)
			
			local theVehicle = false
			for i, vehicle in ipairs ( getElementsByType("vehicle") ) do
				
				local dbid = getData(vehicle, "dbid")
				if tonumber(dbid) == id then
					
					theVehicle = vehicle
					break
				end
			end
			
			if (theVehicle) then
				
				if (id > 0) then
					local row = sql:query_fetch_assoc("SELECT x, y, z, rotx, roty, rotz, dimension, interior FROM vehicles WHERE id =".. sql:escape_string(tonumber(id)) .."")
					if (row) then
				
						local x = row['x']
						local y = row['y']
						local z = row['z']
						local rotx = row['rotx']
						local roty = row['roty']
						local rotz = row['rotz']
						local dim = row['dimension'] 
						local int = row['interior']
					
						setElementDimension(theVehicle, dim)
						setElementInterior(theVehicle, int)
						
						setElementPosition(theVehicle, x, y, z)
						setElementRotation(theVehicle, rotx, roty, rotz)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." respawned vehicle ID ".. tostring( id ) ..".")
						
						outputChatBox("Vehicle has been respawned!", thePlayer, 212, 156, 49)
					end
					
				elseif (id < 0) then	
					outputChatBox("You cannot respawn that vehicle", thePlayer, 255, 0, 0)
				end	
			else
				outputChatBox("Invalid vehicle ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Vehicle ID]", thePlayer, 212, 156, 49)
		end	
	end
end
addCommandHandler("respawnveh", respawnVeh, false, false)

function respawnRemoteVehicle( theVehicle )
	if (theVehicle) then
		
		local id = tonumber( getData( theVehicle, "dbid" ) )
		
		local row = sql:query_fetch_assoc("SELECT x, y, z, rotx, roty, rotz, dimension, interior FROM vehicles WHERE id =".. sql:escape_string( id ) .."")
		if (row) then
		
			local x = row['x']
			local y = row['y']
			local z = row['z']
			local rotx = row['rotx']
			local roty = row['roty']
			local rotz = row['rotz']
			local dim = row['dimension'] 
			local int = row['interior']
			
			setElementDimension(theVehicle, dim)
			setElementInterior(theVehicle, int)
			
			setElementPosition(theVehicle, x, y, z)
			setElementRotation(theVehicle, rotx, roty, rotz)
		end
	end	
end
addEvent("respawnRemoteVehicle", true)
addEventHandler("respawnRemoteVehicle", root, respawnRemoteVehicle)

-- /park
function parkVehicle( thePlayer, commandName )	
	if not isPedDead(thePlayer) then
		
		local vehicle = getPedOccupiedVehicle(thePlayer)
		if (vehicle) then
			
			local dbid = tonumber(getData(vehicle, "dbid"))
			local job = tonumber(getData(vehicle, "job"))
			local vehicleID = tonumber(getData(vehicle, "dbid"))
			local adminduty = tonumber(getData(thePlayer, "adminduty"))
			local admin = tonumber(getData(thePlayer, "admin"))
			local playerFaction = tonumber(getData(thePlayer, "faction"))
			local factionDuty = tonumber(getData(thePlayer, "duty"))
			local vehicleFaction = tonumber(getData(vehicle, "faction"))
				
			local found, hasVehicleKey = exports['[ars]inventory-system']:hasItem(thePlayer, 1, vehicleID) 
					
			if ( job > 0 and adminduty == 1 ) and ( admin > 0 ) or ( hasVehicleKey ) or ( adminduty == 1 ) or ( playerFaction == 4 and factionDuty == 1 ) or ( ( playerFaction > 0 and vehicleFaction > 0 ) and ( playerFaction == vehicleFaction ) ) then
				
				local x, y, z = getElementPosition(vehicle)
				local rotx, roty, rotz = getElementRotation(vehicle)
				local dim, int = getElementDimension(vehicle), getElementInterior(vehicle)

				local update = sql:query("UPDATE vehicles SET `x`=".. sql:escape_string(x) ..", `y`=".. sql:escape_string(y) ..", `z`=".. sql:escape_string(z) ..", `rotx`=".. sql:escape_string(rotx) ..", `roty`=".. sql:escape_string(roty) ..", `rotz`=".. sql:escape_string(rotz) ..", dimension=".. sql:escape_string(dim) ..", interior=".. sql:escape_string(int) .." WHERE `id`=".. sql:escape_string(dbid) .."")
				if (update) then
					outputChatBox("Vehicle has been parked!", thePlayer, 212, 156, 49)
				end
				
				sql:free_result(update)
			else
				outputChatBox("You cannot park this vehicle.", thePlayer, 255, 0, 0)
			end
		end
	end	
end
addCommandHandler("park", parkVehicle, false, false)

--------- [ Various Functions ] ---------
function enterVehicle( thePlayer, seat )
	local owner = tonumber( getData(source, "owner") )
	local faction = tonumber( getData(source, "faction") )
	local playerFaction = tonumber( getData(thePlayer, "faction") )
	local factionDuty = tonumber( getData(thePlayer, "duty") )
	local impounded = tonumber( getData(source, "impounded") )
	
	if ( impounded == 1 ) then
		if ( playerFaction == 4 and factionDuty == 1 ) then
			outputChatBox("Report this vehicle to an admin if it has been here from over a month.", thePlayer, 0, 255, 0)
		else
			removePedFromVehicle(thePlayer)
		end
		
		outputChatBox("This vehicle is Impounded.", thePlayer, 212, 156, 49)
	end	
	
	if ( owner == -1 and faction == -1 ) then -- Not owned by a player, neither by a faction
		outputChatBox("This ".. getVehicleName(source) .." is a civilian vehicle.", thePlayer, 212, 156, 49)
	elseif ( owner > 0 and faction == -1 ) then -- Owned by a player, though not owned by a faction
		
		local result = sql:query_fetch_assoc("SELECT charactername FROM characters WHERE id=".. sql:escape_string(owner) .."")
		if (result) then
			local ownername = result['charactername']
			outputChatBox("This ".. getVehicleName(source) .." is owned by ".. tostring(ownername) ..".", thePlayer, 212, 156, 49)
		else
			local update = sql:query("UPDATE vehicles SET faction='-1', owner='-1' WHERE id=".. sql:escape_string(faction) .."")
			if (update) then
				setData(source, "owner", -1, true)
				setData(source, "faction", -1, true)
			else
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end	
			
			sql:free_result(update)
		end	
	elseif ( owner == -1 and faction > 0 ) then	-- Not owned by a player, although owned by a faction
	
		local result = sql:query_fetch_assoc("SELECT name FROM factions WHERE id=".. sql:escape_string(faction) .."")
		if (result) then
			local ownername = result['name']
			
			if ( playerFaction ~= faction ) then
				if ( bike[getVehicleName(source)] ) then	-- Can't enter faction bikes
				
					removePedFromVehicle(thePlayer)
				end	
			end
			
			outputChatBox("This ".. getVehicleName(source) .." is owned by ".. tostring(ownername) ..".", thePlayer, 212, 156, 49)
		else
			local update = sql:query("UPDATE vehicles SET faction='-1', owner='-1' WHERE id=".. sql:escape_string(faction) .."")
			if (update) then
				setData(source, "owner", -1, true)
				setData(source, "faction", -1, true)
			else
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end	
			
			sql:free_result(update)
		end
	elseif ( owner > 0 and faction > 0 ) then -- Owned by both, we'll remove owner rights from the player,
		
		local update = sql:query("UPDATE vehicles SET owner='-1' WHERE id=".. sql:escape_string(tonumber(getData(source, "dbid"))) .."")
		if (update) then
			
			setData(source, "owner", -1, true)
			
			triggerEvent("playerEnterVehicle", source, thePlayer)
		else
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end	
		
		sql:free_result(update)
	end
	-- 
	local customColors = tonumber( getData( source, "custom_color") )
	
	local isVehicleCustomColored = false
	if ( customColors == 1 ) then
		isVehicleCustomColored = true
	end 
	
	if ( isVehicleCustomColored ) then
		local red1, green1, blue1, red2, green2, blue2 = getVehicleColor( source, true )
		setVehicleColor(source, red1, green1, blue1, red2, green2, blue2)
	else	
		local color1, color2 = getVehicleColor(source)
		setVehicleColor(source, color1, color2, 0, 0)
	end	
end
addEvent("playerEnterVehicle", true)
addEventHandler("playerEnterVehicle", getRootElement(), enterVehicle)
addEventHandler("onVehicleEnter", getRootElement(), enterVehicle)

function getVehicleOwner( owner )
	local owner = tonumber( owner )
	
	if ( owner < 0 ) then
		return "None"
	else	
		local result = sql:query_fetch_assoc("SELECT charactername FROM characters WHERE id=".. sql:escape_string(owner) .."")
		if (result) then
			
			return tostring( result['charactername'] )
		end	
	end	
end

-- Respawn on explode
function vehicleExplode( )
	local dbid = getData(source, "dbid")
	local theVehicle = source
	
	setTimer(function( )
		
		if ( dbid < 0 ) then
			destroyElement(theVehicle)
		else	
			local row = sql:query_fetch_assoc("SELECT x, y, z, rotx, roty, rotz, dimension, interior FROM vehicles WHERE id =".. sql:escape_string(tonumber(dbid)) .."")
			if (row) then
				
				fixVehicle(theVehicle)
				
				local x = row['x']
				local y = row['y']
				local z = row['z']
				local rotx = row['rotx']
				local roty = row['roty']
				local rotz = row['rotz']
				local dim = row['dimension'] 
				local int = row['interior']
				
				setElementDimension(theVehicle, dim)
				setElementInterior(theVehicle, int)
				
				setElementPosition(theVehicle, x, y, z)
				setElementRotation(theVehicle, rotx, roty, rotz)
			end
			
			local update = sql:query("UPDATE vehicles SET health='1000' WHERE id=".. sql:escape_string(tonumber(dbid)) .."")
			sql:free_result(update)
		end	
	end, 20000, 1)	
end
addEventHandler("onVehicleExplode", root, vehicleExplode)

function checkVehiclesInWater( )
	for index, theVehicle in ipairs (getElementsByType("vehicle")) do
		
		local _, _, z = getElementPosition(theVehicle)
		local z = tonumber(z)
		
		if (z <= -3 and not isVehicleBlown(theVehicle)) then
			
			local currZ = z
			setTimer(
				function( )
					
					-- Sinking
					if ( z < currZ ) then 
						blowVehicle(theVehicle)
					end
				end, 5000, 1
			)	
		end
	end	
end
setTimer(checkVehiclesInWater, 600000, 0)
 
function toggleLights( thePlayer )
	if not isPedDead(thePlayer) then
		
		if isPedInVehicle(thePlayer) then
			local veh = getPedOccupiedVehicle(thePlayer)
			if getPedOccupiedVehicleSeat(thePlayer) == 0 then
				
				local lights = getVehicleOverrideLights(veh)
				if (lights == 1) or (lights == 0)  then -- Turned off
					
					-- Turn on
					setVehicleOverrideLights(veh, 2) 
				elseif (lights == 2) then -- Turned on
					
					-- Turn off
					setVehicleOverrideLights(veh, 1) 
				end
			end
		end
	end	
end

local strobes = { }
function toggleStrobes( thePlayer )
	if not isPedDead(thePlayer) then
		if ( isPedInVehicle(thePlayer) ) then
			
			local veh = getPedOccupiedVehicle(thePlayer)
			if ( getPedOccupiedVehicleSeat(thePlayer) == 0 ) and ( emergencyVehicle[getElementModel(veh)] ) then
			
				local lights = getVehicleOverrideLights(veh)
				if (lights == 2) then -- Turned on
					
					if ( strobes[veh] ~= nil ) and ( strobes[veh] == true ) then -- if on
						strobes[veh] = false
						setVehicleLightState(veh, 0, 0)
						setVehicleLightState(veh, 1, 0)
						setVehicleLightState(veh, 2, 0)
						setVehicleLightState(veh, 3, 0)
						
						setVehicleHeadLightColor (veh, 255, 255, 255)
					elseif ( strobes[veh] == nil ) or ( strobes[veh] == false ) then -- if off
						strobes[veh] = true
						changeStrobeColor (thePlayer, veh)
					end
				end
			end
		end
	end	
end

function changeStrobeColor (thePlayer, veh)
	if ( strobes[veh] ~= nil ) and ( strobes[veh] == true ) then
		setVehicleLightState (veh, 0, 0)
		setVehicleLightState (veh, 1, 1)
		setVehicleLightState (veh, 2, 0)
		setVehicleLightState (veh, 3, 1)

		setVehicleHeadLightColor (veh, 0, 0, 255)	
		setTimer(flickerStrobes, 250, 1, thePlayer, veh)
	end	
end

function flickerStrobes(thePlayer, veh)
	if ( strobes[veh] ~= nil ) and ( strobes[veh] == true ) then
		setVehicleLightState (veh, 0, 1)
		setVehicleLightState (veh, 1, 0)
		setVehicleLightState (veh, 2, 1)
		setVehicleLightState (veh, 3, 0)
		
		setVehicleHeadLightColor (veh, 255, 0, 0)
		setTimer(changeStrobeColor, 250, 1, thePlayer, veh)
	end	
end

addEventHandler("onElementDestroy", root,
	function( )
		if ( strobes[source] ) then
			strobes[source] = nil
		end
	end
)
	
function toggleEngine( thePlayer )
	if not isPedDead(thePlayer) then
		
		if isPedInVehicle(thePlayer) then
			
			local veh = getPedOccupiedVehicle(thePlayer)
			
			if ( not bike[getVehicleName(veh)] ) then
				
				if ( getPedOccupiedVehicleSeat( thePlayer ) == 0 ) then
					
					local dbid = tonumber( getData( veh, "dbid" ) )
					local adminDuty = tonumber( getData( thePlayer, "adminduty" ) )
					local admin = tonumber(getData(thePlayer, "admin"))
					local playerFaction = tonumber( getData( thePlayer, "faction" ) )
					local vehicleFaction = tonumber( getData( veh, "faction" ) )
					local job = tonumber( getData( veh, "job") )
					local fuel = tonumber( getData( veh, "fuel") )
					
					local found, hasVehicleKey = exports['[ars]inventory-system']:hasItem(thePlayer, 1, dbid)
					
					local similarFaction = false
					if ( playerFaction > 0 and vehicleFaction > 0 ) and ( playerFaction == vehicleFaction ) then
						similarFaction = true
					end
					
					local onAdminDuty = false
					if ( adminDuty == 1 ) and ( admin > 0 ) then
						onAdminDuty = true
					end	
					
					local jobVehicle = false
					if ( job > 0 ) then
						jobVehicle = true
					end	
					
					local engineOn = getVehicleEngineState(veh)
					if ( not engineOn ) then -- Engine is off
					
						if ( dbid < 0 ) or ( jobVehicle ) or ( hasVehicleKey ) or ( onAdminDuty ) or ( similarFaction ) then 
					
							local brokenState = getData(veh, "enginebroke")
							if ( brokenState == 0 ) then
								
								if ( fuel > 0 ) then
									
									-- Turn it on
									setVehicleEngineState( veh, true )
									setData(veh, "engine", 1, true)
									
									triggerEvent("onVehicleTurnOn", root, veh)
								else
									outputChatBox("Your vehicle is out of fuel.", thePlayer, 255, 0, 0)
								end	
							else
								outputChatBox("Your vehicle's engine is broken!", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("You do not have the keys to this vehicle.", thePlayer, 255, 0, 0)
						end	
					else
						
						-- Turn it off
						setVehicleEngineState( veh, false )
						setData(veh, "engine", 0, true)
						
						triggerEvent("onVehicleTurnOff", root, veh)
					end	
				end
			end	
		end
	end	
end

function checkEngine( thePlayer )
	local engineState = getData(source, "engine")
	if engineState == 0 then
		
		setVehicleEngineState( source, false )
	end	
end
addEventHandler("onVehicleEnter", getRootElement(), checkEngine)

function toggleLock( thePlayer )
	if not isPedDead(thePlayer) then
		
		local veh = getPedOccupiedVehicle(thePlayer) 
		if isElement(veh) then
			
			if ( bike[getVehicleName(veh)] ) then	-- Can't lock a bike
				return
			else	
				if getPedOccupiedVehicleSeat(thePlayer) == 0 or tonumber(getData(veh, "owner")) == tonumber(getData(thePlayer, "dbid")) then
					if isVehicleLocked(veh) then
						setVehicleLocked(veh, false)
						lockUpdate("unlocked", tonumber(getData(veh, "dbid")))
						
						outputChatBox("You unlocked the vehicle doors.", thePlayer, 212, 156, 49)
					else
						setVehicleLocked(veh, true)
						lockUpdate("locked", tonumber(getData(veh, "dbid")))
						
						outputChatBox("You locked the vehicle doors.", thePlayer, 212, 156, 49)
					end
				end	
			end		
		else
			for key, value in ipairs ( getElementsByType("marker") ) do
				local r, g, b = getMarkerColor( value )
				if ( r == 255 and g == 255 and b == 255 ) then
					
					if ( isElementWithinMarker( thePlayer, value ) ) then 
						return
					end
				end
			end
			
			local nearbyVehicles = { }
			for k, vehicle in ipairs ( getElementsByType("vehicle") ) do
				local x, y, z = getElementPosition(thePlayer)
				local vx, vy, vz = getElementPosition(vehicle)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
					
				if distance <= 15 then
					table.insert(nearbyVehicles, vehicle)
				end
			end	
				
			local ownedVehs = { }
			for index, nearbyVeh in pairs ( nearbyVehicles ) do
					
				local vehicleID = tonumber(getData(nearbyVeh, "dbid"))
				local adminDuty = tonumber(getData(thePlayer, "adminduty"))
				local admin = tonumber(getData(thePlayer, "admin"))
				local playerFaction = tonumber(getData(thePlayer, "faction"))
				local vehicleFaction = tonumber(getData(nearbyVeh, "faction"))
				
				local found, hasVehicleKey = exports['[ars]inventory-system']:hasItem(thePlayer, 1, vehicleID) 
				
				local similarFaction = false
				if ( playerFaction > 0 and vehicleFaction > 0 ) and ( playerFaction == vehicleFaction ) then
					similarFaction = true
				end
				
				local onAdminDuty = false
				if ( adminDuty == 1 ) and ( admin > 0 ) then
					onAdminDuty = true
				end	
			
				if ( hasVehicleKey ) or ( onAdminDuty ) or ( similarFaction )  then -- He owns one of the vehicles around him or he is an admin or he and the vehicle belong to the same faction
					
					if ( not bike[getVehicleName(nearbyVeh)] ) then	-- Can't lock a bike
						
						table.insert(ownedVehs, nearbyVeh)
					end	
				end
			end
				
			if #ownedVehs < 1 then 
				return
				
			elseif #ownedVehs > 1 then
				
				local nearestVehicle = nil
				local shortestDistance = 15
				for k, foundVehicles in ipairs ( ownedVehs ) do
						
					local x, y, z = getElementPosition(thePlayer)
					local vx, vy, vz = getElementPosition(foundVehicles)
						
					local distanceFromVehicle = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
					if distanceFromVehicle < shortestDistance then
						shortestDistance = distanceFromVehicle
						nearestVehicle = foundVehicles
					end
				end
						
				if ( nearestVehicle ~= nil ) then
						
					if isVehicleLocked(nearestVehicle) then
						setVehicleLocked(nearestVehicle, false)
						lockUpdate("unlocked", tonumber(getData(nearestVehicle, "dbid")))
						
						playUnlockAlarm( nearestVehicle )
					else
						setVehicleLocked(nearestVehicle, true)
						lockUpdate("locked", tonumber(getData(nearestVehicle, "dbid")))
						
						playLockAlarm( nearestVehicle )
					end
					setPedAnimation(thePlayer, "GHANDS", "gsign3LH", 2000, false, false, false)
				end
					
			elseif #ownedVehs == 1 then
					
				for k, foundVehicle in ipairs ( ownedVehs ) do
					
					if isVehicleLocked(foundVehicle) then
						setVehicleLocked(foundVehicle, false)
						lockUpdate("unlocked", tonumber(getData(foundVehicle, "dbid")))
						
						playUnlockAlarm( foundVehicle )
					else
						setVehicleLocked(foundVehicle, true)
						lockUpdate("locked", tonumber(getData(foundVehicle, "dbid")))
						
						playLockAlarm( foundVehicle )
					end
					setPedAnimation(thePlayer, "GHANDS", "gsign3LH", 2000, false, false, false)
				end
			end
			nearbyVehicles = nil -- empty the tables
			ownedVehs = nil	
		end	
	end	
end

function playLockAlarm( vehicle )
	for i, thePlayer in ipairs ( getElementsByType("player") ) do
		
		local x, y, z = getElementPosition(vehicle)
		local px, py, pz = getElementPosition(thePlayer)
		
		local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
		if distance <= 20 then
			
			triggerClientEvent(thePlayer, "playLockSound", thePlayer, distance)
		end
	end
	
	local lights = getVehicleOverrideLights(vehicle)
	if (lights == 1) then 
		setVehicleOverrideLights(vehicle, 2)
		setTimer(function() setVehicleOverrideLights(vehicle, 1) end, 500, 1)
	elseif (lights == 2) then 
		setVehicleOverrideLights(vehicle, 1)
		setTimer(function() setVehicleOverrideLights(vehicle, 2) end, 500, 1)		
	end
end

function playUnlockAlarm( vehicle )
	for i, thePlayer in ipairs ( getElementsByType("player") ) do
		
		local x, y, z = getElementPosition(vehicle)
		local px, py, pz = getElementPosition(thePlayer)
		
		local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
		if distance <= 20 then
			
			triggerClientEvent(thePlayer, "playUnlockSound", thePlayer, distance)
		end
	end	
	
	local lights = getVehicleOverrideLights(vehicle)
	if (lights == 1) then 
		setVehicleOverrideLights(vehicle, 2)
		setTimer(function() setVehicleOverrideLights(vehicle, 1) end, 500, 1)
	elseif (lights == 2) then 
		setVehicleOverrideLights(vehicle, 1)
		setTimer(function() setVehicleOverrideLights(vehicle, 2) end, 500, 1)		
	end
end

addEventHandler("onVehicleStartEnter", root,
	function( thePlayer )
		for key, value in ipairs ( getElementsByType("marker") ) do
			
			local red, green, blue = getMarkerColor( value )
			local white = red + green + blue
			if ( white == 765 ) and isElementWithinMarker( thePlayer, value ) then
				
				cancelEvent( )
				return
			end
		end	

		if ( isVehicleLocked( source ) ) then
			
			if ( engineBike[ getVehicleName(source) ] ) then
				cancelEvent( )
				outputChatBox("This bike is locked.", thePlayer, 255, 0, 0)
			end	
		end	
	end
)
	
addEventHandler("onVehicleStartExit", root, 	
	function ( thePlayer )
		if ( isVehicleLocked( source ) ) then
			cancelEvent( )
			outputChatBox("The vehicle doors are locked.", thePlayer, 255, 0, 0)
		end	
	end
)

function lockUpdate( state, dbid )
	local query
	if state == "locked" then
		query = "UPDATE vehicles SET locked='1' WHERE id=".. sql:escape_string(dbid) ..""
	elseif state == "unlocked" then
		query = "UPDATE vehicles SET locked='0' WHERE id=".. sql:escape_string(dbid) ..""
	end	
	
	local update = sql:query(tostring(query))
	sql:free_result(update)
end

-- // Called from Resource 'vehicle-shops'
function buyVehicle( thePlayer, price, x, y, z, rot )
	
	local id = getElementModel(source)

	local dim, int = 0, 0
	local owner = getData(thePlayer, "dbid")
	local plate = generateRandomPlate( thePlayer )
	local color1, color2 = getVehicleColor(source)
	local faction = -1
	local job = -1
	local tinted = 0
	
	local vehicle = createVehicle(id, x, y, z, 0, 0, rot, tostring(plate))
	if isElement(vehicle) then
		
		destroyElement(source)	
			
		local insert = sql:query("INSERT INTO vehicles SET model=".. sql:escape_string(id) ..", currx=".. sql:escape_string(x) ..", x=".. sql:escape_string(x) ..", curry=".. sql:escape_string(y) ..", y=".. sql:escape_string(y) ..", currz=".. sql:escape_string(z) ..", z=".. sql:escape_string(z) ..", currrotx='0', rotx='0', currroty='0', roty='0', currrotz=".. sql:escape_string(rot) ..", rotz=".. sql:escape_string(rot) ..", currdimension=".. sql:escape_string(dim) ..", dimension=".. sql:escape_string(dim) ..", currinterior=".. sql:escape_string(int) ..", interior=".. sql:escape_string(int) ..", upgrades='', wheelStates='', panelStates='', doorStates='', color1=".. sql:escape_string(color1) ..", color2=".. sql:escape_string(color2) ..", faction=".. sql:escape_string(faction) ..", owner=".. sql:escape_string(owner) ..", job=".. sql:escape_string(job) ..", plate='".. sql:escape_string(plate) .."', tinted=".. sql:escape_string(tinted) ..", items='', itemvalues=''") 
		if (insert) then
			
			local insertid = sql:insert_id()
			
			local engineVal, engine = 0, false
			if ( bike[getVehicleName( vehicle )] ) then
				engineVal, engine = 1, true
			end
				
			setData(vehicle, "faction", tonumber(faction), true)
			setData(vehicle, "dbid", tonumber(insertid), true)
			setData(vehicle, "owner", tonumber(owner), true)
			setData(vehicle, "fuel", 151, true)
			setData(vehicle, "plate", tostring(plate), true)
			setData(vehicle, "tinted", tonumber(tinted), true)
			setData(vehicle, "engine", engineVal, true)
			setData(vehicle, "enginebroke", 0, true)
			setData(vehicle, "impounded", 0, true)
			setData(vehicle, "handbrake", 0, true)
			setData(vehicle, "job", tonumber(job), true)
			
			setVehicleEngineState(vehicle, engine)
			
			-- Items
			setData(vehicle, "items", "", true) 
			setData(vehicle, "values", "", true) 
			
			setVehicleColor(vehicle, color1, color2, 0, 0)
			
			exports['[ars]inventory-system']:giveItem(thePlayer, 1, tostring(insertid))
			
			takePlayerMoney(thePlayer, price*100)
			outputChatBox("Congratulations! You just bought yourself a ".. getVehicleName(vehicle) ..".", thePlayer, 212, 156, 49)
			
			triggerEvent("giveMoneyToGovernment", thePlayer, price)
		end

		sql:free_result(insert)
	else
		outputChatBox("You do not have enough money.", thePlayer, 255, 0, 0)
	end	
end
addEvent("buyVehicle", true)
addEventHandler("buyVehicle", root, buyVehicle)

--------- [ Resource (re)start ] ---------
local toLoad = { }
local threads = { }
function loadAllVehicles(res)
	local result = sql:query("SELECT id FROM vehicles ORDER BY id ASC")
	if result then
		while true do
			local row = sql:fetch_assoc(result)
			if not row then break end
			
			toLoad[tonumber(row['id'])] = true
		end
		sql:free_result(result)
		
		for id in pairs( toLoad ) do
			
			local co = coroutine.create(loadOneVehicle)
			coroutine.resume(co, id, true)
			table.insert(threads, co)
		end
		setTimer(resume, 1000, 4)
	else
		outputDebugString("Coroutine failure.")
	end
end
addEventHandler("onResourceStart", resourceRoot, loadAllVehicles)

function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end

function loadOneVehicle(id, hasCoroutine)
	if (hasCoroutine == nil) then
		hasCoroutine = false
	end
	
	local row = sql:query_fetch_assoc("SELECT * FROM vehicles WHERE id = " .. sql:escape_string(id) )
	if row then
		
		if (hasCoroutine) then
			coroutine.yield()
		end
		
		local model = row['model'] 
		local x = row['currx']
		local y = row['curry']
		local z = row['currz']
		local rotx = row['currrotx']
		local roty = row['currroty']
		local rotz = row['currrotz']
		local dim = row['currdimension'] 
		local int = row['currinterior'] 
		local fuel = row['fuel']
		local engine = row['engine']
		local locked = row['locked'] 
		local lights = row['lights']
		local sirens = row['sirens']
		local paintjob = row['paintjob']
		local health = row['health']
		local color1 = row['color1']
		local color2 = row['color2']
		
		local customColors = row['custom_colors']
		if ( tostring( customColors ):find( "user" ) ) then
			customColors = "nil"
		end 
		
		local plate = row['plate']
		local faction = row['faction']
		local owner = row['owner']
		local job = row['job']
		local tinted = row['tinted']
		local enginebroke = row['enginebroke']
		local impounded = row['Impounded']
		local handbrake = row['handbrake']
		
		local upgrades = row['upgrades'] 
		
		local items = row['items'] 
		if ( items == nil ) then
			items = ""
		end
		
		local itemvalues = row['itemvalues'] 
		if ( itemvalues == nil ) then
			itemvalues = ""
		end
		
		-- create!
		local vehicle = createVehicle(tonumber(model), tonumber(x), tonumber(y), tonumber(z), tonumber(rotx), tonumber(roty), tonumber(rotz), tostring(plate))
		if isElement(vehicle) then
			
			setElementDimension(vehicle, tonumber(dim)) -- dimension
			setElementInterior(vehicle, tonumber(int)) -- interior
	
			 -- engine
			if tonumber(engine) == 0 then
				setVehicleEngineState(vehicle, false)
			else
				setVehicleEngineState(vehicle, true)
				triggerEvent("onVehicleTurnOn", root, vehicle)
			end	
			
			-- locked/unlocked
			if tonumber(locked) == 0 then
				setVehicleLocked(vehicle, false)
			else
				setVehicleLocked(vehicle, true)
			end
			
			-- lights
			if tonumber(lights) == 1 then
				setVehicleOverrideLights(vehicle, 1)
			else
				setVehicleOverrideLights(vehicle, 2)
			end
			
			-- sirens
			if tonumber(sirens) == 0 then
				setVehicleSirensOn(vehicle, false)
			else
				setVehicleSirensOn(vehicle, true)
			end	
			
			if ( tostring(customColors) == "" or tostring(customColors) == "nil" ) then
				
				setVehicleColor(vehicle, tonumber(color1), tonumber(color2), 0, 0) -- color
				setData(vehicle, "custom_color", 0, true)
			else
				local t = split(tostring(customColors), ",")
		
				setVehicleColor(vehicle, unpack(t))	-- color
				setData(vehicle, "custom_color", 1, true)
			end
			
			setVehiclePaintjob(vehicle, tonumber(paintjob)) -- paintjob
			
			setElementHealth(vehicle, tonumber(health)) -- hp
			
			-- Upgrades
			if (tostring(upgrades) ~= "") then
				local tupgrades = split(upgrades, string.byte(",")) 
				
				for i = 1, #tupgrades do
					addVehicleUpgrade(vehicle, tupgrades[i])
				end	
			end
			
			-- Items
			setData(vehicle, "items", tostring(items), true) 
			setData(vehicle, "values", tostring(itemvalues), true) 
			
			-- element data
			setData(vehicle, "faction", tonumber(faction), true)
			setData(vehicle, "dbid", tonumber(id), true)
			setData(vehicle, "owner", tonumber(owner), true)
			setData(vehicle, "fuel", tonumber(fuel), true)
			setData(vehicle, "plate", tostring(plate), true)
			setData(vehicle, "tinted", tonumber(tinted), true)
			setData(vehicle, "engine", tonumber(engine), true)
			setData(vehicle, "enginebroke", tonumber(enginebroke), true)
			setData(vehicle, "impounded", tonumber(impounded), true)
			setData(vehicle, "handbrake", tonumber(handbrake), true)
			setData(vehicle, "job", tonumber(job), true)
		end
	else
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
end

function disableBlowup()
	local health = getElementHealth(source)

	if (health<=350) then
		setElementHealth(source, 300)
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
	end
end
addEventHandler("onVehicleDamage", getRootElement(), disableBlowup)

function enableHandBrake(source)
	if isPedInVehicle (source) then
		local playerVehicle = getPedOccupiedVehicle (source)
		if (getVehicleOccupant(playerVehicle, 0) == source) then
			if ( not isElementFrozen(playerVehicle) ) then
				if isVehicleOnGround(playerVehicle) or getVehicleType(playerVehicle) == "Boat" then
					setElementFrozen(playerVehicle, true)
				end
			else
				setElementFrozen(playerVehicle, false)
				handbrake = 0
			end
		end
	end
end
addCommandHandler("handbrake", enableHandBrake)
addCommandHandler("hb", enableHandBrake)

--------- [ Vehicle Binds ] ---------
local function bindKeysOnStart( res )
	for i, thePlayer in ipairs ( getElementsByType("player") ) do
		if ( not isKeyBound( thePlayer, "k", "down", toggleLock) ) then
			bindKey(thePlayer, "k", "down", toggleLock)
		end
		
		if ( not isKeyBound( thePlayer, "l", "down", toggleLights) ) then
			bindKey(thePlayer, "l", "down", toggleLights)
		end
		
		if ( not isKeyBound( thePlayer, "j", "down", toggleEngine) ) then
			bindKey(thePlayer, "j", "down", toggleEngine)
		end
		
		if ( not isKeyBound( thePlayer, "p", "down", toggleStrobes) ) then
			bindKey(thePlayer, "p", "down", toggleStrobes)
		end
	end	
end
addEventHandler("onResourceStart", resourceRoot, bindKeysOnStart)
	
function bindVehicleKeys( )
	bindKey(source, "k", "down", toggleLock)
	bindKey(source, "l", "down", toggleLights)
	bindKey(source, "j", "down", toggleEngine)
	bindKey(source, "p", "down", toggleStrobes)
end
addEventHandler("onPlayerJoin", getRootElement(), bindVehicleKeys)
addEvent("bindVehicleKeys", false)
addEventHandler("bindVehicleKeys", getRootElement(), bindVehicleKeys)