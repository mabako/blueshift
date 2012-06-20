--------- [ Taxi Job ] ---------
function onEnterTaxi( vehicle, seat )
	if (getElementData(vehicle, "job") == 3 and getElementData(source, "job") ~= 3 and seat == 0) then 											-- The vehicle & player are not allowed to do taxi job
	
		removePedFromVehicle(source)
		return	
	elseif (getElementData(vehicle, "job") == 3 and getElementData(source, "job") == 3) then
	
		if (seat == 0) then																											-- They are the driver
			
			outputChatBox("Type /jobhelp if you need help regarding your job!", source, 0, 255, 0)
			
			if (getElementData(vehicle, "engine") == 0) then 																				-- Incase they are new and don't know whats wrong..
				
				outputChatBox("Press J to start the vehicle's engine.", source, 219, 105, 29)
			end
		end
	end	
end
addEventHandler("onPlayerVehicleEnter", root, onEnterTaxi)