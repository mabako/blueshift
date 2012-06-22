local sql = exports.sql

--------- [ Department of Motor Vehicles ] ---------
local students = { }

function enterTestVehicle( vehicle, seat )
	if ( getElementData(vehicle, "job") == 10 ) then -- DMV vehicle
		if ( students[source] ) then
	
			if (seat == 0) then
				
				outputChatBox("Follow the checkpoints to complete your Driving Test.", source, 212, 156, 49)
			
				if (getElementData(vehicle, "engine") == 0) then
					outputChatBox("Press J to start the vehicle's engine.", source, 231, 60, 128)
				end
				
				triggerClientEvent(source, "startDrivingTest", source)
			end
		else
			outputChatBox("This vehicle is for Driving Test only.", source, 255, 0, 0)
			removePedFromVehicle( source )
		end	
	end	
end
addEventHandler("onPlayerVehicleEnter", root, enterTestVehicle)

function exitTestVehicle( vehicle, seat )
	if ( getElementData(vehicle, "job") == 10 ) then -- DMV vehicle
		if (seat == 0) then
			
			setVehicleEngineState( vehicle, false )
			setVehicleOverrideLights( vehicle, 1 )
			
			triggerEvent("respawnRemoteVehicle", source, vehicle)
			
			removePlayerStudent( source )
			triggerClientEvent( source, "endDrivingTest", source )
		end	
	end			
end
addEventHandler("onPlayerVehicleExit", root, exitTestVehicle)

-- ## Call Backs
function givePlayerDrivingLicense( )
	local update = sql:query("UPDATE `characters` SET `drivinglicense`='1' WHERE `charactername`='".. sql:escape_string(getPlayerName(source):gsub("_", " ")) .."'")
	if ( update ) then
		
		removePlayerStudent( source )
		setElementData(source, "d:license", 1, true)
	else
		outputDebugString("MySQL Error: Unable to update license!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
	
	sql:free_result(update)
end
addEvent("givePlayerDrivingLicense", true)
addEventHandler("givePlayerDrivingLicense", root, givePlayerDrivingLicense)

function setPlayerStudent( )
	students[source] = true
end
addEvent("setPlayerStudent", true)
addEventHandler("setPlayerStudent", root, setPlayerStudent)	

function removePlayerStudent( thePlayer )
	students[thePlayer] = nil
end
addEvent("removePlayerStudent", true)
addEventHandler("removePlayerStudent", root, removePlayerStudent)		