function c_isPlayerLevelOneDonator( thePlayer )
	if getElementData >= 1 then
		return true
	else
		return false
	end
end

function c_isPlayerLevelTwoDonator( thePlayer )
	if getElementData >= 2 then
		return true
	else
		return false
	end
end

function c_isPlayerLevelThreeDonator( thePlayer )
	if getElementData >= 3 then
		return true
	else
		return false
	end
end	

function c_getPlayerDonatorTitle( thePlayer )
	if getElementData == 1 then
		
		return "Level One Donator"
	elseif getElementData == 2 then
		
		return "Level Two Donator"
	elseif getElementData == 3 then	
	
		return "Level Three Donator"
	else
		return "Non-donator"
	end
end	