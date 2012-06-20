local leaveTimer = { }

--------- [ Sweeper Job ] ---------
function onEnterSweeper( vehicle, seat )
	if (getElementData(vehicle, "job") == 1 and getElementData(source, "job") ~= 1) then -- The vehicle & player are not allowed to do sweeper job
		
		removePedFromVehicle(source)
	elseif (getElementData(vehicle, "job") == 1 and getElementData(source, "job") == 1) then
	
		if (seat == 0) then	-- They are the driver
			
			outputChatBox("Type /jobhelp if you need help regarding your job!", source, 0, 255, 0)
				
			if (getElementData(vehicle, "engine") == 0) then
				outputChatBox("Press J to start the vehicle's engine.", source, 231, 60, 128)	-- Incase they are new..
			end
			
			triggerClientEvent(source, "startSweeperJob", source)	-- Lets begin!
		end
	end	
end
addEventHandler("onPlayerVehicleEnter", root, onEnterSweeper)

function onExitSweeper( vehicle, seat )
	if (getElementData(vehicle, "job") == 1 and getElementData(source, "job") == 1) then
		
		if (seat == 0) then	-- They were in the driver's seat
			
			if isTimer(leaveTimer[source]) then	-- They got out before 15 seconds after the run was complete
				killTimer(leaveTimer[source])
			
				leaveTimer[source] = nil
				return							-- Stop here!	
			end
			
			triggerClientEvent(source, "endSweeperJob", source) -- They got out in the middle
		end
	end
end	
addEventHandler("onPlayerVehicleExit", root, onExitSweeper)

--------- [ Client Call Backs ] ---------

-- They must get out of the vehicle before 15 seconds after finishing the run
function sweeperAbandonTimer( )
	outputChatBox("You have 15 seconds to get out of your vehicle.", source, 83, 236, 220)
	outputChatBox("Re-enter the vehicle to start another run.", source, 83, 236, 220)
	
	leaveTimer[source] = setTimer(removePedFromVehicle, 15000, 1, source)
end
addEvent("sweeperAbandonTimer", true)
addEventHandler("sweeperAbandonTimer", root, sweeperAbandonTimer)

-- Pay the Sweeper
function paySweeperMoney( amount )
	givePlayerMoney(source, amount)
	triggerEvent("takeMoneyFromGovernment", source, amount/100)
end
addEvent("paySweeperMoney", true)
addEventHandler("paySweeperMoney", root, paySweeperMoney)