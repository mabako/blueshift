--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value, sync )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

function updateNametagColor( thePlayer )
	if ( getData(thePlayer, "loggedin") ~= 1 ) then
	
		setPlayerNametagColor(thePlayer, 140, 140, 140)
	elseif ( isPlayerTrialModerator(thePlayer) ) and ( getData(thePlayer, "adminduty") == 1 ) and ( getData(thePlayer, "hiddenadmin") == 0 ) then -- Admin
		
		setPlayerNametagColor(thePlayer, 255, 255, 0)
	else
		local badges = exports['[ars]inventory-system']:getBadges()
		for badgeName, data in pairs(badges) do
			if getData( thePlayer, badgeName ) == 1 then
				setPlayerNametagColor(thePlayer, data.color[1], data.color[1], data.color[2])
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