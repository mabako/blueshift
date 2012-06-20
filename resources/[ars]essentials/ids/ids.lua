--------- [ Player IDs ] ---------
local playerID = { }
addEventHandler("onPlayerJoin", root,
	function( )
		local slot = nil
		
		for i = 1, 128 do
			if ( playerID[ i ] == nil ) then
				
				slot = i
				break
			end
		end
		
		playerID[slot] = source
		setElementData(source, "playerid", tonumber(slot), true)
	end
)

addEventHandler("onPlayerQuit", root,
	function ( )
		local slot = tonumber( getElementData(source, "playerid") )
		if ( slot ) then
			
			playerID[slot] = nil
		end
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function( )
		for i, thePlayer in ipairs( getElementsByType("player") ) do
			
			playerID[ i ] = thePlayer
			setElementData( thePlayer, "playerid", tonumber( i ), true)
		end
	end
)