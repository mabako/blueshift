local paynsprayColShape = nil

addEventHandler( "onClientColShapeHit", resourceRoot,
	function( element, matchingDimension )
		if element == getPedOccupiedVehicle( localPlayer ) and matchingDimension then
			paynsprayColShape = source
			
			-- in a vehicle and driving it?
			if getVehicleOccupant( element, 0 ) == localPlayer then
				createWindow()
			end
			
			addEventHandler( "onClientPlayerVehicleEnter", localPlayer, enterVehicle )
			addEventHandler( "onClientPlayerVehicleExit", localPlayer, hideWindow )
		end
	end
)

addEventHandler( "onClientColShapeLeave", resourceRoot,
	function( element )
		if source == paynsprayColShape and ( element == getPedOccupiedVehicle( localPlayer ) or element == localPlayer ) then
			paynsprayColShape = nil
			
			hideWindow( )
			
			removeEventHandler( "onClientPlayerVehicleEnter", localPlayer, enterVehicle )
			removeEventHandler( "onClientPlayerVehicleExit", localPlayer, hideWindow )
		end
	end
)

-- handler for entering vehicles
function enterVehicle( vehicle, seat )
	if seat == 0 then
		createWindow( )
	end
end

-- Window for do you want to do things?
local window = nil
local screenX, screenY = guiGetScreenSize()

function createWindow( )
	hideWindow( )
	
	local width = 400
	local height = 70
	window = guiCreateWindow( (screenX - width)/2, screenY - 1.5*height, width, height, "Pay'n'Spray, " .. getZoneName( getElementPosition( paynsprayColShape ) ), false ) 
	
	local fix = guiCreateButton( 5, 20, width - 155, height - 20, "Fix my " .. getVehicleName( getPedOccupiedVehicle( localPlayer ) ) .. " ($" .. fixCost .. ")", false, window )
	addEventHandler( "onClientGUIClick", fix,
		function()
			if getPlayerMoney() < fixCost * 100 then
				guiSetEnabled( fix, false )
			else
				-- has enough money, whoo. send it to teh server
				triggerServerEvent( "paynspray:fix", paynsprayColShape )
				hideWindow( )
			end
		end
	)
	
	-- don't enable the button if the player has no money
	if getPlayerMoney() < fixCost * 100 then
		guiSetEnabled( fix, false )
	end
	
	local nothanks = guiCreateButton( width - 140, 20, 140, height - 20, "No, thanks.", false, window )
	addEventHandler( "onClientGUIClick", nothanks, hideWindow, false )
	
	-- button styling, colors are ARGB
	if getElementHealth( getPedOccupiedVehicle( localPlayer ) ) < 999 then
		guiSetProperty( fix, "NormalTextColour", "FFAAFFAA" )
		guiSetProperty( fix, "HoverTextColour", "FF33FF33" )
	end
end

function hideWindow()
	if window then
		destroyElement( window )
		window = nil
	end
end
