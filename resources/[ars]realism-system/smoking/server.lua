--------- [ Smoking System ] ---------	

-- Exported function
function smokeCigarette( thePlayer )
	if ( thePlayer ) then
		
		setElementData( thePlayer, "smoking_thing", 1, true )
		setElementData( thePlayer, "smoking_true", 1, true ) 
	end		
end

-- /throwcig
function throwCigarette( thePlayer, commandName )
	if ( thePlayer ) then
		
		setElementData( thePlayer, "smoking_thing", 0, true )
		setElementData( thePlayer, "smoking_true", 0, true )
	end	
end
addCommandHandler("throwcig", throwCigarette)

-- /switchhand
function switchCigaretteHand( thePlayer, commandName )
	
	local lefthand = tonumber( getElementData( thePlayer, "smoking_lefthand" ) )
	if ( lefthand == 1 ) then -- Switch to right hand
	
		setElementData( thePlayer, "smoking_lefthand", 0, true)
	else					  -- Switch to left hand
		setElementData( thePlayer, "smoking_lefthand", 1, true)
	end	
end
addCommandHandler("switchhand", switchCigaretteHand)

-- Resource Start
function setSmokingData( )
	for key, thePlayer in ipairs( getElementsByType("player") ) do

		setElementData( thePlayer, "smoking_true", 0, true )
		setElementData( thePlayer, "smoking_thing", 0, true )
		setElementData( thePlayer, "smoking_lefthand", 0, true )
	end
end
addEventHandler("onResourceStart",  resourceRoot, setSmokingData)