local sql = exports.sql

--------- [ Friend System ] ---------
function setPlayerAsFriend( thePlayer ) 
	if ( thePlayer ) then
		
		-- Client's Friendlist
		local accountid = getElementData( thePlayer, "accountid")
		
		local sourceFriends = tostring( getElementData( source, "friends") )
		if ( sourceFriends == "none" ) then
			sourceFriends = tostring( accountid ) ..","
		else
			sourceFriends = sourceFriends .. tostring( accountid ) ..","
		end
		
		local update = sql:query("UPDATE `accounts` SET `friends`='".. sql:escape_string( sourceFriends ) .."' WHERE `id`=".. sql:escape_string( tonumber( getElementData(source, "accountid") ) ) .."")
		if ( update ) then
			
			outputChatBox(getPlayerName( thePlayer ):gsub("_", " ") .." was added to your friend list.", source, 212, 156, 49)
			setElementData(source, "friends", tostring(sourceFriends), true)
		end
		
		sql:free_result(update)
		
		-- Player's Friendlist
		local accountid = getElementData( source, "accountid")
		
		local playerFriends = tostring( getElementData( thePlayer, "friends") )
		if ( playerFriends == "none" ) then
			playerFriends = tostring( accountid  ) ..","
		else
			playerFriends = playerFriends .. tostring( accountid ) ..","
		end
		
		local update = sql:query("UPDATE `accounts` SET `friends`='".. sql:escape_string( playerFriends ) .."' WHERE `id`=".. sql:escape_string( tonumber( getElementData(thePlayer, "accountid") ) ) .."")
		if ( update ) then
			
			outputChatBox(getPlayerName( source ):gsub("_", " ") .." was added to your friend list.", thePlayer, 212, 156, 49)
			setElementData(thePlayer, "friends", tostring(playerFriends), true)
		end
		
		sql:free_result(update)
	end	
end
addEvent("setPlayerAsFriend", true)
addEventHandler("setPlayerAsFriend", root, setPlayerAsFriend)

function addPlayerFriend( thePlayer )
	if ( thePlayer ) then
		
		triggerClientEvent(thePlayer, "askPlayerFriend", thePlayer, source)
	end	
end
addEvent("addPlayerFriend", true)
addEventHandler("addPlayerFriend", root, addPlayerFriend)

function removePlayerFriend( thePlayer )
	if ( thePlayer ) then
		
		-- Client's Friendlist
		local accountid = tonumber( getElementData(thePlayer, "accountid") )
		
		local sourceFriends = tostring( getElementData(source, "friends") )
		local t = split(sourceFriends, ",")
		
		local newFriends = ""
		
		for key, value in ipairs ( t ) do
			if ( tonumber( value ) ~= accountid ) then
				
				newFriends = newFriends .. value ..","
			end
		end
		
		local update = sql:query("UPDATE `accounts` SET `friends`='".. sql:escape_string( newFriends ) .."' WHERE `id`=".. sql:escape_string( tonumber( getElementData(source, "accountid") ) ) .."")
		if ( update ) then
			
			outputChatBox(getPlayerName( thePlayer ):gsub("_", " ") .." was removed from your friend list.", source, 212, 156, 49)
			setElementData(source, "friends", tostring(newFriends), true)
		end
		
		sql:free_result(update)
		
		-- Player's Friendlist
		local accountid = tonumber( getElementData(source, "accountid") )
		
		local playerFriends = tostring( getElementData(thePlayer, "friends") )
		local t = split(playerFriends, ",")
		
		local newFriends = ""
		
		for key, value in ipairs ( t ) do
			if ( tonumber( value ) ~= accountid ) then
				
				newFriends = newFriends .. value ..","
			end
		end
		
		local update = sql:query("UPDATE `accounts` SET `friends`='".. sql:escape_string( newFriends ) .."' WHERE `id`=".. sql:escape_string( tonumber( getElementData(thePlayer, "accountid") ) ) .."")
		if ( update ) then
			
			outputChatBox(getPlayerName( source ):gsub("_", " ") .." removed you from their friend list.", thePlayer, 212, 156, 49)
			setElementData(thePlayer, "friends", tostring(newFriends), true)
		end
		
		sql:free_result(update)
	end	
end
addEvent("removePlayerFriend", true)
addEventHandler("removePlayerFriend", root, removePlayerFriend)

function tellPlayer( positive, thePlayer )
	if ( positive ) then
		outputChatBox("Your friend request has been sent to ".. getPlayerName( thePlayer ):gsub("_", " "), source, 212, 156, 49)
	else	
		outputChatBox("Please wait, the Player is already replying to a friend request.", source, 255, 0, 0)
	end	
end
addEvent("tellPlayer", true)
addEventHandler("tellPlayer", root, tellPlayer)