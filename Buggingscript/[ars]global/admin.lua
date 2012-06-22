function getPlayerAdminLevel( thePlayer )
	return getElementData( thePlayer, "admin" ) or 0
end

function isPlayerTrialModerator( thePlayer )
	return getPlayerAdminLevel( thePlayer ) >= 1
end	

function isPlayerModerator( thePlayer )
	return getPlayerAdminLevel( thePlayer ) >= 2
end	

function isPlayerHighModerator( thePlayer )
	return getPlayerAdminLevel( thePlayer ) >= 3
end	

function isPlayerAdministrator( thePlayer )
	return getPlayerAdminLevel( thePlayer ) >= 4
end	

function isPlayerHighAdministrator( thePlayer )
	return getPlayerAdminLevel( thePlayer ) >= 5
end

local scripters = { ["Masta"] = true, ["Jamiez"] = true }
function isPlayerScripter( thePlayer )
	if scripters[ tostring( getElementData( thePlayer, "accountname") ) ] then
		return true
	else
		return false
	end	
end	

local ranks = {"Trial Moderator", "Moderator", "High Moderator", "Administrator", "High Administrator", "Sub-Owner", "Server Owner"}
function getPlayerAdminTitle( thePlayer )
	return ranks[thePlayer] or ranks[getPlayerAdminLevel(thePlayer)] or "Player"
end

function onlineAdmins( thePlayer, commandName )
	local admins = { }
	for k, player in ipairs ( getElementsByType("player") ) do
		-- logged in?
		if getElementData( player, "loggedin" ) and isPlayerTrialModerator( player ) then
			-- can we even see that guy?
			if getElementData( player, "hiddenadmin" ) == 0 or isPlayerTrialModerator( thePlayer ) then
				table.insert(admins, {player, getPlayerAdminLevel( player ), getPlayerName(player):gsub("_", " ")})
			end
		end
	end
	
	table.sort(admins, function( a, b )
		if b[2] < a[2] then
			return true
		end
		
		return b[2] == a[2] and b[3] > a[3]
	end)
	
	outputChatBox("~~~ Online Staff: ~~~", thePlayer, 212, 156, 49)
	if #admins > 0 then
		for _, admin in ipairs(admins) do
			local r, g, b = nil, nil, nil
			local duty = "(Off Duty)"
			if getElementData( admin[1], "adminduty") == 1 then
				r, g, b = 212, 156, 49
				duty = "(On Duty)"
			end	
			
			local username = ""
			if isPlayerTrialModerator( thePlayer ) then
				username = "[".. tostring( getElementData( admin[1], "accountname" ) ) .."] "
			end
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(admin[1]) .." ".. admin[3] .." ".. duty, thePlayer, r, g, b)
		end
	else
		outputChatBox("No staff online at the moment.", thePlayer)
	end
end
addCommandHandler("admins", onlineAdmins, false, false)
addCommandHandler("staff", onlineAdmins, false, false)