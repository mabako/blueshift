local function updateIndicators( vehicle, elementdata, state )
	if state == nil then
		return
	end
	
	local old = getElementData( vehicle, elementdata )
	if old ~= state then
		if state == true then
			setElementData( vehicle, elementdata, state )
		else
			setElementData( vehicle, elementdata, false )
			removeElementData( vehicle, elementdata )
		end
	end
end

addEvent( 'indicators', true )
addEventHandler( 'indicators', root,
	function( left, right )
		local vehicle = getPedOccupiedVehicle( client )
		if vehicle then
			updateIndicators(vehicle, 'i:left', left)
			updateIndicators(vehicle, 'i:right', right)
		end
	end,
	false
)


--[[
* indicator_left and indicator_right commands
Changes the state of the indicators for the current vehicle.
--]]
local function switchIndicatorState ( player, indicator )
	-- First check that we are in a vehicle.
	local v = getPedOccupiedVehicle(player)
	if v then
		-- check for the correct vehicle type
		if getVehicleType(v) == "Automobile" or getVehicleType(v) == "Bike" or getVehicleType(v) == "Quad" then
			-- Check that we are the vehicle driver
			if getVehicleOccupant(v, 0) == player then
				-- Switch the indicator state
				local dataName = 'i:' .. indicator
				local currentValue = getElementData(v, dataName) or false
				
				if indicator == 'left' then
					updateIndicators(v, 'i:left', not currentValue)
				else
					updateIndicators(v, 'i:right', not currentValue)
				end
			end
		end
	end
end
addCommandHandler('indicator_left', function (player) switchIndicatorState(player, 'left') end, false)
addCommandHandler('indicator_right', function (player) switchIndicatorState(player, 'right') end, false)


addEventHandler( 'onVehicleRespawn', root,
	function( )
		updateIndicators(vehicle, 'i:left', false)
		updateIndicators(vehicle, 'i:right', false)
	end
)