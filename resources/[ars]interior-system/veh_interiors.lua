--------- [ Interior Spawn ] ---------
function startVehicleInteriors( )
	for key, theVehicle in ipairs ( getElementsByType("vehicle") ) do
		if ( getElementModel( theVehicle ) == 508 ) then -- Journey
		
			createVehicleInterior( theVehicle )
		end
	end	
end
addEventHandler("onResourceStart", resourceRoot, startVehicleInteriors)

function createVehicleInterior( theVehicle )
	if ( theVehicle ) then
		
		local interiorID = tonumber( getElementData( theVehicle, "dbid" ) )
		local vehicleFaction = tonumber( getElementData( theVehicle, "faction" ) )
		local vehicleOwner = tonumber( getElementData( theVehicle, "owner" ) )
		if ( interiorID < 0 ) or ( vehicleOwner <= 0 ) or ( vehicleFaction > 0 ) then
			
			return
		else	
			local interiorOwner = getElementData( theVehicle, "owner" )
			
			local interiorLocked = 0
			if isVehicleLocked( theVehicle ) then
				interiorLocked = 1
			end	
			
			local entranceDimension = getElementDimension( theVehicle )
			local entranceInterior = getElementInterior( theVehicle )
			
			local exitInterior = 1
			local exitDimension = interiorID
			
			-- Pre-defined
			local interiorType = 1
			local interiorName = "Journey Trailer"
			local interiorPrice = 0
			local interiorRented = 0
			
			-- Entrance
			local entranceMarker = createMarker(0, 0, 3, "cylinder", 1.5, 255, 255, 255, 50)
			attachElements( entranceMarker, theVehicle, 1.5, 0.25, -1, 0, 0, 0 )
			
			setElementDimension( entranceMarker, entranceDimension )
			setElementInterior( entranceMarker, entranceInterior )
			
			setElementData( entranceMarker, "name", tostring( interiorName ), true )
			setElementData( entranceMarker, "owner", tonumber( interiorOwner ), true )
			setElementData( entranceMarker, "dbid", tonumber( -interiorID ), true )
			setElementData( entranceMarker, "type", tonumber( interiorType ), true )
			setElementData( entranceMarker, "locked", tonumber( interiorLocked ), true )
			setElementData( entranceMarker, "price", tonumber( interiorPrice ), true )
			setElementData( entranceMarker, "rented", tonumber( interiorRented ), true )
			setElementData( entranceMarker, "elevator", 0, true )
			
			-- Exit
			local exitMarker = createMarker( 1930.1464, -2379.3242, 12.7187, "cylinder", 2, 255, 255, 255, 50)
			setElementDimension( exitMarker, exitDimension )
			setElementInterior( exitMarker, exitInterior )
			
			setElementData( exitMarker, "name", tostring( interiorName ), true )
			setElementData( exitMarker, "owner", tonumber( interiorOwner ), true )
			setElementData( exitMarker, "dbid", tonumber( -interiorID ), true )
			setElementData( exitMarker, "type", tonumber( interiorType ), true )
			setElementData( exitMarker, "locked", tonumber( interiorLocked ), true )
			setElementData( exitMarker, "price", tonumber( interiorPrice ), true )
			setElementData( exitMarker, "rented", tonumber( interiorRented ), true )
			setElementData( exitMarker, "elevator", 0, true )
		
			setElementParent( exitMarker, entranceMarker )
			
			-- Add Interior
			addInteriorToDimension( exitDimension )
		end	
	end
end