function findPlayer( thePlayer, partialName, options )
	if partialName == "*" then
		return thePlayer
	elseif tonumber(partialName) then -- The id was given
		for k, v in ipairs (getElementsByType("player")) do
			local id = getElementData(v, "playerid")
				
			if (id == tonumber(partialName)) then
				return v
			end
		end
		
		if not options.hideNoPlayers then
			outputChatBox("There is no player with ID " .. partialName .. ".", thePlayer, 255, 0, 0)
		end
		return nil
	elseif tostring(partialName) then -- The name was given
		local possiblePlayers = {}
		for k, v in ipairs (getElementsByType("player")) do
			local name = string.lower(getPlayerName(v))
				
			if (string.find(name, string.lower(tostring(partialName)))) then
				table.insert(possiblePlayers, v)
			end
		end
		
		if #possiblePlayers == 1 then
			return possiblePlayers[1]
		elseif #possiblePlayers == 0 then
			if not options.hideNoPlayers then
				outputChatBox("There is no player with a name like " .. partialName .. ".", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Found " .. #possiblePlayers .. " players matching " .. partialName .. ".", thePlayer, 255, 127, 0)
			for _, v in ipairs(possiblePlayers) do
				outputChatBox("  [".. getElementData(v, "playerid") .."] ".. getPlayerName(v):gsub("_", " "), thePlayer, 255, 255, 0)
			end
		end
		return nil
	end
end