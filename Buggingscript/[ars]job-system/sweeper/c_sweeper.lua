--------- [ Routes ] ---------

local route = { }
route[1] = { }
route[2] = { }

route[1][1] = { 1638.0410, -1538.8720, 13.5933 }
route[1][2] = { 1660.2773, -1455.2431, 13.3865 }
route[1][3] = { 1468.8232, -1438.4072, 13.3828 }
route[1][4] = { 1426.9453, -1577.3828, 13.3621 }
route[1][5] = { 1427.0058, -1717.0986, 13.3828 }
route[1][6] = { 1554.7685, -1734.7949, 13.3828 }
route[1][7] = { 1566.9775, -1857.6757, 13.3828 }
route[1][8] = { 1692.0888, -1825.3730, 13.3828 }
route[1][9] = { 1807.7226, -1834.8837, 13.3828 }
route[1][10] = { 1824.25, -1626.0976, 13.3828 }
route[1][11] = { 1852.7919, -1474.0830, 13.3902 }
route[1][12] = { 1670.8125, -1438.1728, 13.3828 }
route[1][13] = { 1638.0410, -1538.8720, 13.5933 }

route[2][1] = { 1638.0410, -1538.8720, 13.5933 }
route[2][2] = { 1655.3662, -1455.0595, 13.3833 }
route[2][3] = { 1468.6367, -1443.4404, 13.3828 }
route[2][4] = { 1431.7597, -1577.5000, 13.3622 }
route[2][5] = { 1432.0126, -1717.3837, 13.3828 }
route[2][6] = { 1554.8808, -1729.6201, 13.3828 }
route[2][7] = { 1572.0986, -1857.8681, 13.3828 }
route[2][8] = { 1687.1308, -1825.1962, 13.3828 }
route[2][9] = { 1807.8710, -1829.9150, 13.3906 }
route[2][10] = { 1819.2509, -1625.8925, 13.3828 }
route[2][11] = { 1845.4433, -1472.7519, 13.3913 }
route[2][12] = { 1670.6269, -1443.3281, 13.3828 }
route[2][13] = { 1638.0410, -1538.8720, 13.5933 }


--------- [ Server Calls ] ---------
function startSweeperJob( )
	createSweeperCheckpoint( )
end
addEvent("startSweeperJob", true)
addEventHandler("startSweeperJob", localPlayer, startSweeperJob)	

function endSweeperJob( )
	removeSweeperCheckpoint( )
end
addEvent("endSweeperJob", true)
addEventHandler("endSweeperJob", localPlayer, endSweeperJob)

--------- [ Globals ] ---------
local currMarker, nextMarker = nil, nil
local currBlip, nextBlip = nil, nil
local rand = math.random(1, 2)
local stage = 0

--------- [ Sweeper Job ] ---------
function createSweeperCheckpoint( )
	if (stage == 0) then -- Begin
	
		stage = 1
		
		local currX, currY, currZ = unpack(route[rand][stage])		-- Get the position of the current marker
		local nextX, nextY, nextZ = unpack(route[rand][stage+1])	-- Get the position of the next marker
	
		-- Create Em'!
		currMarker = createMarker(currX, currY, currZ, "checkpoint", 2, 255, 255, 0, 200, localPlayer)
		currBlip = createBlip(currX, currY, currZ, 0, 2, 255, 194, 14, 255, 0, 99999.0, localPlayer )
	
		nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, 62, 65, 196, 200, localPlayer)
		nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, 62, 65, 196, 255, 0, 99999.0, localPlayer)	
	end	
end
	
function hitSweeperCheckpoint( hitPlayer, matchingDimension )
	if (hitPlayer == localPlayer and isPedInVehicle(localPlayer)) then				-- Ensure that whoever hit the marker is the client
		if (getVehicleName(getPedOccupiedVehicle(localPlayer)) == "Sweeper") then 	-- Check if client hit the marker in a sweeper
		
			if (source == currMarker) then	 -- Keep going
				
				stage = stage + 1		 	 -- Next stage
			
				playSoundFrontEnd(6)
				
				local currR, currG, currB = nil, nil, nil
				local nextR, nextG, nextB = nil, nil, nil
				
				if (stage == 12) then -- Hit the third last checkpoint
				
					currR, currG, currB = 255, 255, 0
					nextR, nextG, nextB = 255, 0, 0	-- The last marker is red :P	
				elseif (stage == 13) then -- Hit the second last checkpoint
					
					destroyElement(currMarker)		-- Destroy the marker that was hit
					destroyElement(currBlip)
					
					setMarkerSize(nextMarker, 2)	-- make the next marker identical to the current marker
					stage = stage + 1				-- next stage		
				
					return							-- Stop!
				else										-- Otherwise,
					currR, currG, currB = 255, 255, 0		
					nextR, nextG, nextB = 62, 65, 196
				end
				
				destroyElement(currMarker)					-- Destroy the marker that was hit
				destroyElement(currBlip)
				
				currMarker, currBlip = nextMarker, nextBlip		-- our next marker becomes our current marker
				
				setMarkerSize(currMarker, 2)					-- Change the current marker's color and size
				setMarkerColor(currMarker, currR, currG, currB)
				setBlipSize(currBlip, 2)
				setBlipColor(currBlip, currR, currG, currB, 255)
				
				local nextX, nextY, nextZ = unpack(route[rand][stage+1])	-- Get the position of the next marker
	
				-- Create it
				nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, nextR, nextG, nextB, 200, localPlayer)
				nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, nextR, nextG, nextB, 255, 0, 99999.0, localPlayer)
				
			elseif (source == nextMarker and stage == 14) then -- End of the line
			
				playSoundFrontEnd(13)
				
				destroyElement(nextMarker)		-- Destroy the last remaining marker
				destroyElement(nextBlip)
				
				outputChatBox("You completed your sweeper run!", 0, 255, 0)
				outputChatBox("Please park the sweeper before leaving.", 0, 255, 0)
				
				paySweeper( 60 )	-- Pay Them
				
				-- Reset Globals
				currMarker, nextMarker = nil, nil
				currBlip, nextBlip = nil, nil
				rand = math.random(1, 2)
				stage = 0
				
				triggerServerEvent("sweeperAbandonTimer", localPlayer)		-- Start the countdown for abandoning the vehicle
			end
		end	
	end	
end
addEventHandler("onClientMarkerHit", root, hitSweeperCheckpoint)

--------- [ Various Functions ] ---------

-- End the run when the player leaves the vehicle..
function removeSweeperCheckpoint( )
	if (currMarker) then
		destroyElement(currMarker)
		destroyElement(currBlip)
	end
		
	if (nextMarker) then
		destroyElement(nextMarker)
		destroyElement(nextBlip)
	end
	
	currMarker, nextMarker = nil, nil
	currBlip, nextBlip = nil, nil
	rand = math.random(1, 2)
	stage = 0
end

-- Pay the Sweeper
function paySweeper ( amount )
	local amount = tonumber(amount*100)
	
	triggerServerEvent("paySweeperMoney", localPlayer, amount)
end	