function getPlayerPosition( thePlayer, commandName )
	if isPlayerTrialModerator(thePlayer) or isPlayerScripter(thePlayer) then
		
		local x, y, z = getElementPosition(thePlayer)
		local rot = getPedRotation(thePlayer)
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)
		
		rot = string.format("%d", rot)
		
		outputChatBox(("%.4f, %.4f, %.4f"):format(x, y, z), thePlayer, 212, 156, 49)
		outputChatBox("Rotation: ".. rot, thePlayer, 212, 156, 49)
		outputChatBox("Interior: ".. int, thePlayer, 212, 156, 49)
		outputChatBox("Dimension: ".. dim, thePlayer, 212, 156, 49)
	end	
end
addCommandHandler("getpos", getPlayerPosition, false, false)
