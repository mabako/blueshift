function updateNametagColor( thePlayer )
	if not getElementData(thePlayer, "loggedin") then
	
		setPlayerNametagColor(thePlayer, 140, 140, 140)
	elseif ( isPlayerTrialModerator(thePlayer) ) and ( getElementData(thePlayer, "adminduty") == 1 ) and ( getElementData(thePlayer, "hiddenadmin") == 0 ) then -- Admin
		
		setPlayerNametagColor(thePlayer, 255, 255, 0)
	else
		local badges = exports['[ars]inventory-system']:getBadges()
		for badgeName, data in pairs(badges) do
			if getElementData( thePlayer, badgeName ) == 1 then
				setPlayerNametagColor(thePlayer, data.color[1], data.color[2], data.color[3])
				return
			end
		end
		
		if ( isPlayerLevelOneDonator( thePlayer ) ) then -- Donator
			setPlayerNametagColor(thePlayer, 166, 141, 4)	
		else
			setPlayerNametagColor(thePlayer, 255, 255, 255) -- Player
		end
	end
end

function onStart( res )
	for key, value in ipairs( getElementsByType( "player" ) ) do
		updateNametagColor( value )
	end
end
addEventHandler("onResourceStart", resourceRoot, onStart)	