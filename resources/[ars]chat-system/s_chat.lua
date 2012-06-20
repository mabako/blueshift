--[[ 
TO DO:
-- /me 
-- /do 
-- /s(hout) 
-- /w(hisper) 
-- /o 
-- /a 
-- /su 
-- /l 
-- /h 
-- /dv 
-- /don 
-- /f 
-- /d 
-- /r 
]]--
local g_OOCState = false
local sql = exports.sql

-- Helper to output long chat lines
-- best example is prolly /b:
--   before = My char: (( [text at the beginning of each line]
--   text = whatever said in ooc
--   after = )) [text at the end of each line]
function outputLongChatBox(before, text, after, ...)
	ourText = tostring(before) .. tostring(text) .. tostring(after)
	if #ourText == 0 then return false
	elseif #ourText > 128 then
		-- find a "close" space character from the possible end of the string, so words are (ideally) not split in the middle
		local space = 128 - #before - #after
		for i = 128 - #before - #after, 108 - #before - #after, -1 do
			local char = text:sub(i, i)
			if char == '.' or char == ' ' or char == ',' or char == ';' or char == '!' or char == '?' then
				space = i
				break
			end
		end
		return outputChatBox(before .. text:sub(1, space) .. after, ...) and outputLongChatBox(before, text:sub(space + 1), after, ...)
	else
		-- not too long, actually.
		return outputChatBox(before .. text .. after, ...)
	end
end

-- ////// Local CHAT \\\\\\	
-- /say
function localChat( thePlayer, message, language )
	if not isPedDead(thePlayer) and message then
		
		local message = tostring( message )
		
		outputLongChatBox("[English] ".. getPlayerName(thePlayer):gsub("_", " ") .." says: ", message, "", thePlayer, 255, 255, 255)
		
		-- Convey the message to all the players around him by doing a loop
		for k, players in ipairs ( getElementsByType("player") ) do
				
			local x, y, z = getElementPosition(thePlayer)
			local pX, pY, pZ = getElementPosition(players)
			local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
				
			if (distance <= 20) then
					
				-- Color should be according to the distance
				local msgR, msgG, msgB
				if (distance <= 6) then
					msgR, msgG, msgB = 255, 255, 255
				elseif (distance > 6 and distance <= 12) then
					msgR, msgG, msgB = 200, 200, 200
				elseif (distance > 12 and distance <= 20) then	
					msgR, msgG, msgB = 145, 145, 145
				end	
					
				if getElementData(thePlayer, "loggedin") and ( not isPedDead(thePlayer) ) and ( players ~= thePlayer ) then
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
				
						outputLongChatBox("[English] " .. getPlayerName(thePlayer):gsub("_", " ") .." says: ", message, "", players, msgR, msgG, msgB)
					end
				end	
			end	
		end

	end	
end

-- /b
function localOOC( thePlayer, commandName, ... )
	if not isPedDead(thePlayer) then
		if (...) then
			local message = table.concat({...}, " ")
			-- Convey the message to all the players around him by doing a loop
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
				
				if (distance <= 20) then
					if getElementData(thePlayer, "loggedin") and ( not isPedDead(thePlayer) ) then
						
						if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
							
							outputLongChatBox(getPlayerName(thePlayer):gsub("_", " ") ..": (( ", message, " ))", players, 61, 180, 219)
						end	
					end
				end	
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Text]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)	

-- /s(hout)
function shoutLocal( thePlayer, commandName, ... )
	if not isPedDead(thePlayer) then
		if (...) then
			local message = table.concat({...}, " ")
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
					
				if (distance <= 30) then
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
						outputLongChatBox("[English] ".. getPlayerName(thePlayer):gsub("_", " ") .." shouts: ", message .. "!!", "", players, 255, 255, 255)
					end	
				end
			end	
			
			triggerClientEvent(thePlayer, "callTextBubble", thePlayer, message .."!!", 2)
		else
			outputChatBox("SYNTAX: /".. commandName .." [Text]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("s", shoutLocal, false, false)
addCommandHandler("shout", shoutLocal, false, false)
	
-- /w(hisper)
function whisperLocal( thePlayer, commandName, ... ) 	
	if not isPedDead(thePlayer) then
		if (...) then
			local message = table.concat({...}, " ")
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
					
				if (distance <= 2) then
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
						outputLongChatBox("[English] ".. getPlayerName(thePlayer):gsub("_", " ") .." whispers: ", message, "", players, 200, 200, 200)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Text]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("w", whisperLocal, false, false)
addCommandHandler("whisper", whisperLocal, false, false)

-- /me
function meAction( thePlayer, commandName, ... )
	if not isPedDead(thePlayer) then
		if (commandName) then 
			if (...) then
				local message = table.concat({...}, " ")
				for k, players in ipairs ( getElementsByType("player") ) do
				
					local x, y, z = getElementPosition(thePlayer)
					local pX, pY, pZ = getElementPosition(players)
					local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
						
					if (distance <= 20) then
						if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
							outputLongChatBox(" * ", getPlayerName(thePlayer):gsub("_", " ") .." ".. message, "", players, 127, 88, 205)
						end
					end	
				end
			else
				outputChatBox("SYNTAX: /me [Action]", thePlayer, 212, 156, 49)
			end	
		end
	end	
end
addEvent("meAction", true)
addEventHandler("meAction", root, meAction)
addCommandHandler("me", meAction, false, false)

-- /do
function doAction( thePlayer, commandName, ... )
	if not isPedDead(thePlayer) then
		if (...) then
			local message = table.concat({...}, " ")
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
						
				if (distance <= 20) then
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
					
						outputLongChatBox(" * ", message, " ((".. getPlayerName(thePlayer):gsub("_", " ") .."))", players, 127, 88, 205)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Event/Notification]", thePlayer, 212, 156, 49)
		end
	end
end
addEvent("doAction", true)
addEventHandler("doAction", root, doAction)
addCommandHandler("do", doAction, false, false)
	
-- /togglobal
function toggleGChat( thePlayer, commandName, ... )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if (...) then
			reason = table.concat({...}, " ")
		else
			reason = ""
		end
		
		if not g_OOCState then
			g_OOCState = true
			
			if string.len(reason) > 0 then
				outputChatBox("Global OOC is now enabled (".. reason ..")", getRootElement(), 0, 255, 0)
			else
				outputChatBox("Global OOC is now enabled.", getRootElement(), 0, 255, 0)
			end	
		elseif g_OOCState then
			g_OOCState = false
			
			if string.len(reason) > 0 then
				outputChatBox("Global OOC is now disabled (".. reason ..")", getRootElement(), 255, 0, 0)
			else
				outputChatBox("Global OOC has been disabled.", getRootElement(), 255, 0, 0)
			end		
		end	
	end
end
addCommandHandler("togglobal", toggleGChat, false, false)
addCommandHandler("togooc", toggleGChat, false, false)
	
-- Global Chat	
function globalOOC( thePlayer, commandName, ...)
	if (...) then
		
		if (g_OOCState) or not (g_OOCState) and (exports['[ars]global']:isPlayerTrialModerator(thePlayer)) then	
		
			if (getElementData(thePlayer, "muted") == 0) then
				local message = table.concat({...}, " ")
				for k, v in ipairs (getElementsByType("player")) do
					if getElementData(v, "loggedin") and (getElementData(v, "globalooc") == 1) then
						outputLongChatBox("[".. getElementData(thePlayer, "playerid") .."] ".. getPlayerName(thePlayer):gsub("_", " ") ..": (( ", message, " ))", v, 95, 166, 163)
					end	
				end
			else
				outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Global Chat is currently disabled.", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("SYNTAX: /o [Message]", thePlayer, 212, 156, 49)
	end
end
addCommandHandler("o", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)	

-- /pm	
function privateMessage( thePlayer, commandName, partialPlayerName, ... )
	if (partialPlayerName) and (...) then
		local message = table.concat({...}, " ")
		local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
		if foundPlayer then
			if getElementData(foundPlayer, "loggedin") then
				
				local thePlayerAdminlevel = exports['[ars]global']:getPlayerAdminLevel( thePlayer )
				local targetPlayerAdminLevel = exports['[ars]global']:getPlayerAdminLevel( foundPlayer )
				
				if ( isPlayerPrivateMessagingDisabled( foundPlayer ) ) and ( targetPlayerAdminLevel >= thePlayerAdminlevel ) then
					
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is ignoring Private Messages.", thePlayer, 212, 156, 49)
					return
				else	
					outputLongChatBox("PM sent to [".. getElementData(foundPlayer, "playerid") .."] ".. getPlayerName(foundPlayer):gsub("_", " ") ..": ", message, "", thePlayer, 255, 255, 0)
					outputLongChatBox("PM from [".. getElementData(thePlayer, "playerid") .."] ".. getPlayerName(thePlayer):gsub("_", " ") ..": ", message, "", foundPlayer, 255, 255, 0)
					
					outputDebugString("PM from " .. getPlayerName(thePlayer):gsub("_", " ") .. " to " .. getPlayerName(foundPlayer):gsub("_", " ")	.. ": " .. message)
				end	
			else
				outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
			end
		end
	else
		outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Message]", thePlayer, 212, 156, 49)
	end
end	
addCommandHandler("pm", privateMessage, false, false)
	
function togglePrivateMessages( thePlayer )
	if ( exports['[ars]global']:isPlayerLevelOneDonator( thePlayer ) or exports['[ars]global']:isPlayerTrialModerator( thePlayer ) ) then
		
		if ( isPlayerPrivateMessagingDisabled( thePlayer ) ) then
			
			local update = sql:query("UPDATE `accounts` SET `togpm`='0' WHERE `id`=".. sql:escape_string( tonumber( getElementData( thePlayer, "accountid") ) ) .."")
			if ( update ) then
				
				setElementData( thePlayer, "togglepm", false, false )
				outputChatBox("You are no longer ignoring Private Messages.", thePlayer, 212, 156, 49)
			end
		elseif ( not isPlayerPrivateMessagingDisabled( thePlayer ) ) then
			
			local update = sql:query("UPDATE `accounts` SET `togpm`='1' WHERE `id`=".. sql:escape_string( tonumber( getElementData( thePlayer, "accountid") ) ) .."")
			if ( update ) then
				
				setElementData( thePlayer, "togglepm", true, false )
				outputChatBox("You are now ignoring Private Messages.", thePlayer, 212, 156, 49)
			end	
		end	
	end
end
addCommandHandler("togpm", togglePrivateMessages, false, false)
	
function isPlayerPrivateMessagingDisabled( thePlayer )
	return getElementData( thePlayer, "togglepm" )
end
	
-- ////// ADMIN CHAT \\\\\\

-- /a(dminchat)
function adminChat(thePlayer, commandName, ...)
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (...) then
			local message = table.concat({...}, " ")
			for k, v in ipairs (getElementsByType("player")) do
				
				if getElementData(v, "loggedin") then
					if exports['[ars]global']:isPlayerTrialModerator(v) then
						outputLongChatBox("(".. exports['[ars]global']:getPlayerAdminTitle(thePlayer) ..") ".. getPlayerName(thePlayer):gsub("_", " ") ..": ", message, "", v, 54, 181, 75)
					end
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)	
		end	
	end
end
addCommandHandler("a", adminChat, false, false) 

-- /ann(ouncement)
function annChat(thePlayer, commandName, ...)
	if exports['[ars]global']:isPlayerModerator(thePlayer) then
		if (...) then
			local message = table.concat({...}, " ")
			for k, v in ipairs (getElementsByType("player")) do
			
				if getElementData(v, "loggedin") then
				
					outputChatBox("~~ Announcement from Administration ~~", v, 212, 156, 49)
					outputLongChatBox("", message, "", v, 212, 156, 49)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("ann", annChat)

-- /don(ator chat)
function donatorChat( thePlayer, commandName, ...)
	if exports['[ars]global']:isPlayerLevelOneDonator(thePlayer) or exports['[ars]global']:isPlayerTrialModerator(thePlayer) then	
		if (...) then		
			local message = table.concat({...}, " ")
			for k, players in ipairs ( getElementsByType("player") ) do
				if getElementData(players, "loggedin") then
					local donatorlevel = exports['[ars]global']:getPlayerDonatorTitle( thePlayer )
					local adminlevel = exports['[ars]global']:getPlayerAdminTitle( thePlayer )
					
					local level = ""
					if ( donatorlevel == "Non-donator" ) then
						level = adminlevel
					else
						level = donatorlevel
					end
					
					if (exports['[ars]global']:isPlayerLevelOneDonator(players) or exports['[ars]global']:isPlayerTrialModerator(players)) then
						outputLongChatBox("(".. level ..") ".. getPlayerName(thePlayer):gsub("_", " ") ..": ", message, "", players, 166, 141, 4)
					end	
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 210, 108, 58)
		end	
	end
end
addCommandHandler("don", donatorChat, false, false)
addCommandHandler("donator", donatorChat, false, false)

-- /gov(ernment announcement)
function govChat(thePlayer, commandName, ...)
	if (...) then
		if ( getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 ) then -- PD/FD
			
			if (getElementData(thePlayer, "muted") == 0) then
				local message = table.concat({...}, " ")
				for k, v in ipairs (getElementsByType("player")) do
					if getElementData(v, "loggedin") then
						outputChatBox("~~ Government Announcement from ".. getPlayerName(thePlayer):gsub("_", " ") .." ~~", v, 0, 183, 239)
						outputLongChatBox("", message, "", v, 0, 183, 239)
					end
				end
			else
				outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
			end
		end
	else
		outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
	end
end
addCommandHandler("gov", govChat)

-- /m(egaphone)
function useMegaPhone(thePlayer, commandName, ...)
	if not isPedDead(thePlayer) then
		if (...) then
			if ( getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 ) then -- PD/FD
				
				if ( getElementData(thePlayer, "muted") == 0 ) then
					
					local message = table.concat({...}, " ")
					for k, players in ipairs ( getElementsByType("player") ) do
				
						local x, y, z = getElementPosition(thePlayer)
						local pX, pY, pZ = getElementPosition(players)
						local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
						
						if (distance <= 50) then
							if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
					
								outputLongChatBox("[English] " .. getPlayerName(thePlayer):gsub("_", " ") .. "'s megaphone: ", message, "", players, 255, 255, 0)
							end		
						end
					end
				else
					outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
				end
			end
		else	
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("m", useMegaPhone, false, false)

-- /f(action)
function factionOOC(thePlayer, commandName, ...)
	if (...) then
		local theTeam = getPlayerTeam(thePlayer)
		local theTeamName = getTeamName(theTeam)
		local playerName = getPlayerName(thePlayer)
		local playerFaction = getElementData(thePlayer, "faction")
		
		if (playerFaction > 0) then
			local message = table.concat({...}, " ")
			for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
				if isElement( arrayPlayer ) then
					if getPlayerTeam( arrayPlayer ) == theTeam then
						if getElementData(arrayPlayer, "loggedin") then
							outputLongChatBox("[FACTION OOC] " .. getPlayerName(thePlayer):gsub("_", " ") .. ": ", message, "", arrayPlayer, 3, 237, 237)
						end	
					end
				end
			end
		end
	else
		outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
	end
end
addCommandHandler("f", factionOOC, false, false)

-- /d(epartment)
local departmentTeams = {
	-- [long name] = short name
	["Los Santos Police Department"] = "LSPD",
	["Los Santos Emergency Services"] = "LSFD",
	["Los Santos Vehicle Services"] = "LSVS",
	["Federal Bureau of Investigation"] = "FBI",
}
function depChat(thePlayer, commandName, ...)
	local theTeam = getPlayerTeam(thePlayer)
	if (...) and theTeam then
		-- if it's a faction with access to /d, it should be in departmentTeams. If that's not the case, ignore it.
		local teamName = departmentTeams[tostring(getTeamName(theTeam))]
		if teamName then
			if (getElementData(thePlayer, "muted") == 0) then
				local message = table.concat({...}, " ")
				
				for team in pairs(departmentTeams) do
					for key, value in ipairs(getPlayersInTeam(getTeamFromName(team)) or {}) do
						if getElementData(value, "loggedin") then
							outputLongChatBox("[DEPARTMENT " .. teamName .. "] " .. getPlayerName(thePlayer):gsub("_", " ") .. " says: ", message, "", value, 0, 102, 255)
						end	
					end
				end
			else
				outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
			end		
		end
	else
		outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
	end
end
addCommandHandler("d", depChat, false, false)

-- /r(adio)
function radioChat( thePlayer, commandName, ... )
	if not isPedDead(thePlayer) then
		if (...) then
			local message = table.concat({...}, " ")
			local hasRadio = exports['[ars]inventory-system']:hasItem(thePlayer, 4)
			if ( hasRadio ) then 
			
				local frequency = tonumber( getElementData(thePlayer, "radio") )
				if ( frequency > 0 ) then
					
					for key, foundPlayer in ipairs ( getElementsByType("player") ) do
						if getElementData( foundPlayer, "loggedin" ) then
							local hasRadio = exports['[ars]inventory-system']:hasItem(foundPlayer, 4)
							local matchFrequency = tonumber( getElementData(foundPlayer, "radio") )
							
							if ( hasRadio and matchFrequency == frequency ) then
								
								if ( foundPlayer ~= thePlayer ) then
									outputLongChatBox("[RADIO #".. frequency .. "] (( ".. getPlayerName(thePlayer):gsub("_", " ") .." )): ", message, "", foundPlayer, 70, 54, 224)
								end
							end
						end	
					end	
					
					outputLongChatBox("[RADIO #".. frequency .. "] (( ".. getPlayerName(thePlayer):gsub("_", " ") .." )): ", message, "", thePlayer, 70, 54, 224)
				else
					outputChatBox("/tuneradio to set your radio's frequency.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("You do not have a radio.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Message ]", thePlayer, 212, 156, 49)
		end	
	end
end
addCommandHandler("r", radioChat, false, false)

function tuneRadio( thePlayer, commandName, frequency )
	if not isPedDead(thePlayer) then
		if ( frequency ) then
			frequency = tonumber( frequency )
			
			local hasRadio = exports['[ars]inventory-system']:hasItem(thePlayer, 4)
			if ( hasRadio ) then 
				
				local update = sql:query("UPDATE `characters` SET `radio`=".. sql:escape_string(frequency) .." WHERE `id`=".. sql:escape_string(tonumber(getElementData(thePlayer, "dbid"))) .."")
				if ( update ) then
					setElementData(thePlayer, "radio", frequency, true)
					outputChatBox("You tuned your frequency to #".. frequency ..".", thePlayer, 212, 156, 49)
				end	
			else
				outputChatBox("You do not have a radio.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Frequency number ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tuneradio", tuneRadio, false, false)	

-- ////// RETURN FUNCTIONS \\\\\\
-- /find	
function findPerson( thePlayer, commandName, partialPlayerName)
	
	local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
	if foundPlayer then
		outputChatBox("[".. getElementData(foundPlayer, "playerid") .."] ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 0, 255, 0)
	end
end
addCommandHandler("find", findPerson)

function bindOOC( )
	bindKey(source, "u", "down", "chatbox", "GlobalOOC")
	bindKey(source, "b", "down", "chatbox", "LocalOOC")
end
addEventHandler("onPlayerJoin", getRootElement(), bindOOC)
addEvent("bindOOC", true)
addEventHandler("bindOOC", getRootElement(), bindOOC)	
	
function bindOnResourceStart( res )
	for k, v in ipairs ( getElementsByType("player") ) do
		triggerEvent("bindOOC", v)
	end
end
addEventHandler("onResourceStart", resourceRoot, bindOnResourceStart)
	
function useChat( message, messageType )
	-- Disable default MTA Chat
	cancelEvent()
	
	if not isPedDead(source) then
		if ( messageType == 0 ) then -- Local Text
			localChat( source, message, language )
		elseif messageType == 1 then -- /me
			meAction( source, "me", message )
		elseif messageType == 2 then -- Team Say
		end
	end
end
addEventHandler("onPlayerChat", getRootElement(), useChat)	
