--------- [ Fuel Meter ] ---------
local vehicles = { }

function onVehicleTurnOn( theVehicle )
	if ( getElementType( theVehicle ) == "vehicle" ) then
		
		vehicles[theVehicle] = tonumber( getElementData(theVehicle, "fuel") )
	end	
end
addEvent("onVehicleTurnOn", true)
addEventHandler("onVehicleTurnOn", root, onVehicleTurnOn)

function onVehicleTurnOff( theVehicle )
	if ( getElementType( theVehicle ) == "vehicle" ) then
		
		vehicles[theVehicle] = nil
	end	
end
addEvent("onVehicleTurnOff", true)
addEventHandler("onVehicleTurnOff", root, onVehicleTurnOff)

function takeVehicleFuel( )
	for key, value in pairs ( vehicles ) do
		
		if ( vehicles[key] > 0 ) then
			
			vehicles[key] = tonumber( vehicles[key] ) - 0.3 -- Decrease
			
			setElementData( key, "fuel", tonumber( vehicles[key] ), true )
		else
			local thePlayer = getVehicleOccupant( key )
			if ( thePlayer ) then
				
				outputChatBox("Your vehicle is out of fuel.", thePlayer, 255, 0, 0)
			end
			
			setVehicleEngineState( key, false )
			setElementData(key, "engine", 0, true)
			
			vehicles[key] = nil
		end	
	end	
end
setTimer( takeVehicleFuel, 10000, 0 )

--------- [ Client Callbacks ] ---------
function refuelFromGasStation( theVehicle ) 
	if ( theVehicle ) then
		
		takePlayerMoney( source, 130 )
		triggerEvent("giveMoneyToGovernment", source, 130 )
		
		outputChatBox("Your vehicle has been refuelled for $130.", source, 212, 156, 49)
		setElementData( theVehicle, "fuel", 151, true )
	end
end
addEvent("refuelFromGasStation", true)
addEventHandler("refuelFromGasStation", root, refuelFromGasStation)	