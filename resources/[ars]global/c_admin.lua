function c_getPlayerAdminLevel( )
	return getElementData( localPlayer, "admin" ) or 0
end

function c_isPlayerTrialModerator( )
	return c_getPlayerAdminLevel( ) >= 1
end	

function c_isPlayerModerator( )
	return c_getPlayerAdminLevel( ) >= 2
end	

function c_isPlayerHighModerator( )
	return c_getPlayerAdminLevel( ) >= 3
end	

function c_isPlayerAdministrator( )
	return c_getPlayerAdminLevel( ) >= 4
end	

function c_isPlayerHighAdministrator( )
	return c_getPlayerAdminLevel( ) >= 5
end

local scripters = { ["Masta"] = true, ["Jamiez"] = true }
function c_isPlayerScripter( thePlayer )
	if scripters[ tostring( getElementData( thePlayer, "accountname" ) ) ] then
		return true
	else
		return false
	end	
end
