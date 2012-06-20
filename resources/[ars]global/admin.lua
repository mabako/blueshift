function isPlayerTrialModerator( thePlayer )
	if getElementData( thePlayer, "admin") >= 1 then
		
		return true
	else
		return false
	end	
end	

function isPlayerModerator( thePlayer )
	if getElementData( thePlayer, "admin") >= 2 then
		
		return true
	else
		return false
	end	
end	

function isPlayerHighModerator( thePlayer )
	if getElementData( thePlayer, "admin") >= 3 then
		
		return true
	else
		return false
	end	
end	

function isPlayerAdministrator( thePlayer )
	if getElementData( thePlayer, "admin") >= 4 then
		
		return true
	else
		return false
	end	
end	

function isPlayerHighAdministrator( thePlayer )
	if getElementData( thePlayer, "admin") >= 5 then
		
		return true
	else
		return false
	end	
end

local scripters = { ["Masta"] = true, ["Jamiez"] = true }
function isPlayerScripter( thePlayer )
	if scripters[ tostring( getElementData( thePlayer, "accountname") ) ] then
		return true
	else
		return false
	end	
end	

function getPlayerAdminTitle( thePlayer )
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

function getPlayerAdminLevel( thePlayer )
	return getElementData( thePlayer, "admin")
end	

function onlineAdmins( thePlayer, commandName )
	local admins = { }
	for k, player in ipairs ( getElementsByType("player") ) do
		-- logged in?
		if getElementData( player, "loggedin" ) and isPlayerTrialModerator( player ) then
			-- can we even see that guy?
			if getElementData( player, "hiddenadmin" ) == 0 or isPlayerTrialModerator( thePlayer ) then
				table.insert(admins, {player, getElementData( player, "admin"), getPlayerName(player):gsub("_", " ")})
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