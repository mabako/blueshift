-- ## Route 
local route = 
{
	{ 1751.7246, -1700.2539, 13.3828 },
	{ 1749.1708, -1730.4433, 13.3921 },
	{ 1692.1347, -1715.1718, 13.3828 },
	{ 1689.8916, -1594.8925, 13.3852 },
	{ 1659.9023, -1582.4257, 13.3906 },
	{ 1660.0097, -1444.1435, 13.3828 },
	{ 1611.8837, -1438.1621, 13.3828 },
	{ 1606.6953, -1304.9951, 17.2812 },
	{ 1458.7080, -1297.0488, 13.3906 },
	{ 1443.8730, -1239.1904, 13.3828 },
	{ 1344.3154, -1239.9726, 13.5546 },
	{ 1333.4853, -1277.9609, 13.3828 },
	{ 1253.8818, -1289.9589, 13.3909 },
	{ 1273.4501, -1403.6318, 13.0345 },
	{ 1398.6083, -1412.4414, 13.3905 },
	{ 1650.1435, -1440.6787, 13.3828 },
	{ 1671.5253, -1594.5136, 13.3828 },
	{ 1750.3125, -1691.7968, 13.3828 }
}
-- ## Globals
local currMarker, nextMarker = nil, nil
local currBlip, nextBlip = nil, nil
local stage = 0

--------- [ Department of Motor Vehicles ] ---------
function startDrivingTest( )
	if (stage == 0) then
	
		stage = 1
		
		local currX, currY, currZ = unpack(route[stage])		
		local nextX, nextY, nextZ = unpack(route[stage+1])	
	
		currMarker = createMarker(currX, currY, currZ, "checkpoint", 2, 255, 255, 0, 200, localPlayer)
		currBlip = createBlip(currX, currY, currZ, 0, 2, 255, 194, 14, 255, 0, 99999.0, localPlayer )
	
		nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, 0, 255, 0, 200, localPlayer)
		nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, 0, 255, 0, 255, 0, 99999.0, localPlayer)	
	end	
end
addEvent("startDrivingTest", true)
addEventHandler("startDrivingTest", localPlayer, startDrivingTest)
	
function endDrivingTest( )
	if ( currMarker ) then
		destroyElement( currMarker )
		destroyElement( currBlip )
	end

	if ( nextMarker ) then
		destroyElement( nextMarker )
		destroyElement( nextBlip )
	end	
	
	-- ## Reset Globals
	currMarker, nextMarker = nil, nil
	currBlip, nextBlip = nil, nil
	stage = 0
end
addEvent("endDrivingTest", true)
addEventHandler("endDrivingTest", localPlayer, endDrivingTest)
	
function hitDrivingTestMarker ( hitPlayer, matchingDimension )
	if ( hitPlayer == localPlayer and isPedInVehicle( localPlayer ) ) then				
		if (getVehicleName(getPedOccupiedVehicle(localPlayer)) == "Manana") then 	
		
			if (source == currMarker) then	 
				
				stage = stage + 1		 	 
			
				playSoundFrontEnd(6)
				
				local currR, currG, currB = nil, nil, nil
				local nextR, nextG, nextB = nil, nil, nil
					
				if (stage == 17) then 
				
					currR, currG, currB = 255, 255, 0
					nextR, nextG, nextB = 255, 0, 0						
				elseif (stage == 18) then 
					
					destroyElement(currMarker)		
					destroyElement(currBlip)
					
					setMarkerSize(nextMarker, 2)							
					
					stage = stage + 1						
					return							
				else										
					currR, currG, currB = 255, 255, 0		
					nextR, nextG, nextB = 0, 255, 0
				end
				
				destroyElement(currMarker)					
				destroyElement(currBlip)
				
				currMarker, currBlip = nextMarker, nextBlip		
				
				setMarkerSize(currMarker, 2)					
				setMarkerColor(currMarker, currR, currG, currB)
				setBlipSize(currBlip, 2)
				setBlipColor(currBlip, currR, currG, currB, 255)
				
				local nextX, nextY, nextZ = unpack(route[stage+1])	
				nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, nextR, nextG, nextB, 200, localPlayer)
				nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, nextR, nextG, nextB, 255, 0, 99999.0, localPlayer)
				
			elseif (source == nextMarker and stage == 19) then 
				
				playSoundFrontEnd(13)
		
				destroyElement(nextMarker)		
				destroyElement(nextBlip)
				
				outputChatBox("You completed your Driving Test!", 0, 255, 0)
				
				triggerServerEvent("givePlayerDrivingLicense", localPlayer)
				
				-- ## Reset Globals
				currMarker, nextMarker = nil, nil
				currBlip, nextBlip = nil, nil
				stage = 0
			end
		end	
	end	
end
addEventHandler("onClientMarkerHit", root, hitDrivingTestMarker)	