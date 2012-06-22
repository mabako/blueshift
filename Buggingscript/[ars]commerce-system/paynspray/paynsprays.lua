local paynsprays = {
	{ x = 2063.9306, y = -1831.5781, z = 13 }, -- Idlewood
	{ x = 1025.0195, y = -1023.6083, z = 31 }, -- Temple
	{ x = 487.8691, y = -1742.4277, z = 10 }, -- Santa Maria Beach
}

addEventHandler( "onResourceStart", resourceRoot,
	function()
		for _, data in ipairs( paynsprays ) do
			-- create a blip for each paynspray
			createBlip( data.x, data.y, data.z, 63, 2, 255, 0, 0, 255, 0, 200.0 )
			
			-- create a col tube
			createColTube( data.x, data.y, data.z, 4, 3 )
		end
	end
)

addEvent( "paynspray:fix", true )
addEventHandler( "paynspray:fix", resourceRoot, -- binding to resource root = only the colshapes created above trigger this event
	function( )
		if isElementWithinColShape( client, source ) then
			-- is it the driver of any vehicle?
			local vehicle = getPedOccupiedVehicle( client )
			if vehicle and getVehicleOccupant( vehicle, 0 ) == client then
				if getPlayerMoney( client ) < fixCost * 100 then
					outputChatBox( "You can't afford to fix your vehicle.", client, 255, 0, 0 )
				else
					takePlayerMoney( client, fixCost * 100 )
					fixVehicle( vehicle )
					
					outputChatBox("Fixed your " .. getVehicleName( vehicle ) .. " for $" .. fixCost .. ".", client, 0, 255, 0 )
				end
			end
		end
	end
)
