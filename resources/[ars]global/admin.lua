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
	admins["Trial-Moderator"] = { }
	admins["Moderator"] = { }
	admins["High-Moderator"] = { }
	admins["Administrator"] = { }
	admins["High-Administrator"] = { }
	admins["Sub-Owner"] = { }
	admins["Server-Owner"] = { }
	
	for k, player in ipairs ( getElementsByType("player") ) do
		
		local adminlevel = tonumber( getElementData( player, "admin") )
		if ( adminlevel ~= nil and adminlevel > 0 ) and getElementData( player, "loggedin" ) then
			
			if adminlevel == 1 then
				table.insert(admins["Trial-Moderator"], player)
			elseif adminlevel == 2 then	
				table.insert(admins["Moderator"], player)
			elseif adminlevel == 3 then	
				table.insert(admins["High-Moderator"], player)
			elseif adminlevel == 4 then	
				table.insert(admins["Administrator"], player)
			elseif adminlevel == 5 then	
				table.insert(admins["High-Administrator"], player)
			elseif adminlevel == 6 then	
				table.insert(admins["Sub-Owner"], player)
			elseif adminlevel == 7 then	
				table.insert(admins["Server-Owner"], player)
			end	
		end	
	end
	
	local count = 0
	outputChatBox("~~~ Online Staff: ~~~", thePlayer, 212, 156, 49)
	
	-- Server Owner
	for iOwner = 1, #admins["Server-Owner"] do
		local Owner = admins["Server-Owner"][iOwner]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if ( getElementData( Owner, "adminduty") == 1 ) then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( getElementData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( getElementData( Owner, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( getElementData( Owner, "hiddenadmin" ) == 1 ) then
			
			if ( getElementData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(Owner) .." ".. getPlayerName(Owner):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	-- Sub-Owner
	for iSubOwner = 1, #admins["Sub-Owner"] do
		local SubOwner = admins["Sub-Owner"][iSubOwner]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if getElementData( SubOwner, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( getElementData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( getElementData( SubOwner, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( getElementData( SubOwner, "hiddenadmin" ) == 1 ) then
			
			if ( getElementData( thePlayer, "admin" ) == 0 ) then 
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(SubOwner) .." ".. getPlayerName(SubOwner):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	-- High Administrators
	for iHighAdmin = 1, #admins["High-Administrator"] do
		local HighAdmin = admins["High-Administrator"][iHighAdmin]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if getElementData( HighAdmin, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( getElementData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( getElementData( HighAdmin, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( getElementData( HighAdmin, "hiddenadmin" ) == 1 ) then
			
			if ( getElementData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(HighAdmin) .." ".. getPlayerName(HighAdmin):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
		
	-- Administrators
	for iAdministrator = 1, #admins["Administrator"] do
		local Administrator = admins["Administrator"][iAdministrator]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if getElementData( Administrator, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( getElementData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( getElementData( Administrator, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( getElementData( Administrator, "hiddenadmin" ) == 1 ) then
			
			if ( getElementData( thePlayer, "admin" ) == 0 ) then 
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(Administrator) .." ".. getPlayerName(Administrator):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	-- High Moderators
	for iHighMod = 1, #admins["High-Moderator"] do
		local HighMod = admins["High-Moderator"][iHighMod]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if getElementData( HighMod, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( getElementData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( getElementData( HighMod, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( getElementData( HighMod, "hiddenadmin" ) == 1 ) then
			
			if ( getElementData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
		
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(HighMod) .." ".. getPlayerName(HighMod):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
		
	-- Moderators
	for iModerator = 1, #admins["Moderator"] do
		local Moderator = admins["Moderator"][iModerator]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if getElementData( Moderator, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( getElementData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( getElementData( Moderator, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( getElementData( Moderator, "hiddenadmin" ) == 1 ) then
			
			if ( getElementData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
		
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(Moderator) .." ".. getPlayerName(Moderator):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end

	-- Trial Moderators
	for iTrialMod = 1, #admins["Trial-Moderator"] do
		local TrialMod = admins["Trial-Moderator"][iTrialMod]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if getElementData( TrialMod, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( getElementData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( getElementData( TrialMod, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( getElementData( TrialMod, "hiddenadmin" ) == 1 ) then
			
			if ( getElementData( thePlayer, "admin" ) == 0 ) then 
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(TrialMod) .." ".. getPlayerName(TrialMod):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	if ( count == 0 ) then
		outputChatBox("No staff online at the moment.", thePlayer)
	end
end
addCommandHandler("admins", onlineAdmins, false, false)
addCommandHandler("staff", onlineAdmins, false, false)