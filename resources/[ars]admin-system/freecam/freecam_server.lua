﻿-- FREECAM
local thePlayers = { }

function enableFreecam( thePlayer, theDimension )
	if ( thePlayer ) then
		
		outputChatBox("You enabled Freecam.", thePlayer, 212, 156, 49)
		triggerClientEvent( thePlayer, "setFreecamEnabled", root, theDimension )
	end	
end

function disableFreecam( thePlayer )
	if ( thePlayer ) then
		
		outputChatBox("You disabled Freecam.", thePlayer, 212, 156, 49)
		triggerClientEvent( thePlayer, "setFreecamDisabled", root )
	end	
end

function dropPlayer( camX, camY, camZ, camInterior, camDimension )
	if ( camX and camY and camZ ) then
		
		-- Drop
		setElementInterior( source, camInterior) 
		setElementDimension( source, camDimension )
		setElementPosition( source, camX, camY, camZ ) 
		
		setElementFrozen( source, false )
		setCameraTarget(source, source)
	
		thePlayers[source] = nil
	end	
end
addEvent("dropPlayer", true)
addEventHandler("dropPlayer", root, dropPlayer)

function toggleFreecam( thePlayer )
	if exports['[ars]global']:isPlayerTrialModerator( thePlayer ) then
	
		if ( not isPlayerFreecaming( thePlayer ) ) then
			
			enableFreecam( thePlayer, getElementDimension( thePlayer ) )
			thePlayers[thePlayer] = true
			
			-- Place
			setElementPosition( thePlayer, 0, 0, 3 )
			setElementFrozen( thePlayer, true )
			
			-- Hide
			setElementAlpha( thePlayer, 0 )
			setData( thePlayer, "invisible", 1, true )
			setData( thePlayer, "nametag", 0, true )
			
		else
			disableFreecam( thePlayer )
			
			-- Hide
			setElementAlpha( thePlayer, 255 )
			setData( thePlayer, "invisible", 0, true )
			setData( thePlayer, "nametag", 1, true )
		end	
	end	
end
addCommandHandler("freecam", toggleFreecam, false, false )

function isPlayerFreecaming( thePlayer )
	if ( thePlayers[thePlayer] == nil ) then
		return false
	else	
		return true
	end	
end	