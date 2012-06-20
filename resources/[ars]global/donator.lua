function isPlayerLevelOneDonator( thePlayer )
	if getElementData(thePlayer, "donator") >= 1 then
		return true
	else
		return false
	end
end

function isPlayerLevelTwoDonator( thePlayer )
	if getElementData(thePlayer, "donator") >= 2 then
		return true
	else
		return false
	end
end

function isPlayerLevelThreeDonator( thePlayer )
	if getElementData(thePlayer, "donator") >= 3 then
		return true
	else
		return false
	end
end	

function getPlayerDonatorTitle( thePlayer )
	if getElementData(thePlayer, "donator") == 1 then
		
		return "Level One Donator"
	elseif getElementData(thePlayer, "donator") == 2 then
		
		return "Level Two Donator"
	elseif getElementData(thePlayer, "donator") == 3 then	
	
		return "Level Three Donator"
	else
		return "Non-donator"
	end
end