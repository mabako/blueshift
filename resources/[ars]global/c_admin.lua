function c_isPlayerTrialModerator( thePlayer )
	if getElementData( thePlayer, "admin") >= 1 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerModerator( thePlayer )
	if getElementData( thePlayer, "admin") >= 2 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerHighModerator( thePlayer )
	if getElementData( thePlayer, "admin") >= 3 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerAdministrator( thePlayer )
	if getElementData( thePlayer, "admin") >= 4 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerHighAdministrator( thePlayer )
	if getElementData( thePlayer, "admin") >= 5 then
		
		return true
	else
		return false
	end	
end

local scripters = { ["Masta"] = true, ["Jamiez"] = true }
function c_isPlayerScripter( thePlayer )
	if scripters[ tostring( getElementData( thePlayer, "accountname" ) ) ] then
		return true
	else
		return false
	end	
end	

function c_getPlayerAdminTitle( thePlayer )
	if getElementData( thePlayer, "admin") == 1 then
		
		return "Trial Moderator"
	elseif getElementData( thePlayer, "admin") == 2 then
		
		return "Moderator"
	elseif getElementData( thePlayer, "admin") == 3 then
		
		return "High Moderator"
	elseif getElementData( thePlayer, "admin") == 4 then
		
		return "Administrator"
	elseif getElementData( thePlayer, "admin") == 5 then
		
		return "High Administrator"
	elseif getElementData( thePlayer, "admin") == 6 then
		
		return "Sub-Owner"
	elseif getElementData( thePlayer, "admin") == 7 then
		
		return "Server Owner"	
	else
		return "Player"
	end
end

function c_getPlayerAdminLevel( thePlayer )
	return getElementData( thePlayer, "admin")
end	