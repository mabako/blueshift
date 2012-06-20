local sql = exports.sql

--------- [ Login Screen ] ---------
local function generateSalt()
	local salt = ""
	for i = 1, 64 do
		salt = salt .. string.char(math.random(33, 122))
	end
	return salt
end

function attemptRegister( username, password )
	if username and password then
		
		local username = tostring(username)
		
		local result = sql:query_fetch_assoc("SELECT `id` FROM `accounts` WHERE `username`='".. sql:escape_string(tostring(username)) .."'")
		if ( result ) then
			
			triggerClientEvent(source, "showSignInMessage", source, "An account with the given username already exists.", 282)
			return 
		else
			local password = tostring(password)
			local salt = generateSalt()
			local safepassword = string.upper(md5(salt .. password))
			
			local update = sql:query("INSERT INTO `accounts` SET `username`='".. sql:escape_string(tostring(username)) .."', `salt` = '" .. sql:escape_string(salt) .. "', `password`='".. sql:escape_string(tostring(safepassword)) .."', `ip`='".. getPlayerIP(source) .."', `registerdate`=NOW()")
			if ( update ) then
				
				triggerClientEvent(source, "showSignInMessage", source, "You successfully registered!", 150)
			else
				
				triggerClientEvent(source, "showSignInMessage", source, "Failed to register your account.", 150)
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end
			
			sql:free_result(update)
		end
	end
end
addEvent("attemptRegister", true)
addEventHandler("attemptRegister", getRootElement(), attemptRegister)

function attemptLogin( username, password, remember )
	local username = tostring(username)
	local password = tostring(password)
	local passwordQuery
	
	if ( string.len( password ) < 64 ) then -- Not MD5'd
		passwordQuery = "`password`=MD5(CONCAT(salt, '".. sql:escape_string(tostring(password)) .."'))"
	else
		-- to successfully login with a token, two things need to be given:
		-- 1. you have the same serial as when the token was created
		-- 2. the correct username is given
		passwordQuery = "logintoken = '" .. md5(getPlayerSerial(source) .. tostring(password)) .. "'"
		password = nil
	end
	
	local result = sql:query_fetch_assoc("SELECT * FROM accounts WHERE `username`='".. sql:escape_string(tostring(username)) .."' AND " .. passwordQuery)
	if result then
		
		if tonumber(result['banned']) == 0 then -- they are not banned
			-- we generate a new random 64-chars long string here which is stored client-side.
			-- md5(playerSerial .. that string) is stored on the server
			local newToken = "NULL"
			if ( remember == 1 ) then
				newToken = generateSalt()
				triggerClientEvent( source, "savePlayerDetails", source, username, newToken )
				
				newToken = "'" .. md5(getPlayerSerial(source) .. newToken) .. "'"
			end
			
			-- when using the old salt, we want passwords to be updated to a dynamic salt.
			local passwordUpdate = ""
			if password and #result.salt < 64 then
				local salt = generateSalt()
				password = md5(salt .. password)
				passwordUpdate = ", salt = '" .. sql:escape_string(salt) .. "', password = '" .. sql:escape_string(password) .. "'"
			end
			
			local update = sql:query("UPDATE `accounts` SET `lastlogin`=NOW(), logintoken = " .. newToken .. passwordUpdate .. " WHERE `username`='".. sql:escape_string(tostring(username)) .."'")
			if (update) then
				-- raaah. we store account things here.
				setElementData(source, "accountname", tostring(result.username), true)
				setElementData(source, "accountid", tonumber(result.id), true)
				setElementData(source, "adminreports", tonumber(result.reports), true)
				setElementData(source, "donator", tonumber(result.donator), true)
				setElementData(source, "togglepm", tonumber(result.togpm) == 1, false)
				setElementData(source, "tutorial", tonumber(result.tutorial) == 1, false)
				
				local friends = tostring(result.friends)
				if ( friends == "nil" ) or ( string.find( friends, "userdata" ) ) or ( string.len( friends ) == 0 ) then
					friends = "none"
				end
				setElementData(source, "friends", friends, true)
				setElementData(source, "skinmods", tonumber(result.skinmods), false)
				setElementData(source, "weaponmods", tonumber(result.weaponmods), false)
				setElementData(source, "vehiclemods", tonumber(result.vehiclemods), false)
				
				if tonumber(result.admin) > 0 then
					setElementData(source, "admin", tonumber(result.admin), false)
					triggerClientEvent(source, "elementdata", source, "admin", tonumber(result.admin))
					setElementData(source, "adminduty", tonumber(result.adminduty), true)
					setElementData(source, "hiddenadmin", tonumber(result.hiddenadmin), true)
				else
					if getElementData(source, "admin") then
						removeElementData(source, "admin")
						triggerClientEvent(source, "elementdata", source, "admin", false)
					end
					
					if getElementData(source, "adminduty") then
						removeElementData(source, "adminduty")
					end
				end
				
				triggerEvent("loginPlayer", source, true)
			else
				triggerClientEvent(source, "showSignInMessage", source, "Unknown login error.", 150)
			end
			
			sql:free_result(update)
		else -- if they are banned in the database
			local bans = getBans( )
			local nick = result['username']
			local ip = result['ip']
			local found = false
			for k, v in ipairs(bans) do
				if (nick == getBanNick(v) or ip == getBanIP(v)) then
				
					found = true -- they still exist in the banlist.xml
				end
			end	
			
			if (found) then -- ban evading ( perma ban )
				local update = sql:query("UPDATE `accounts` SET `banned`='1', `banned_reason`='Ban Evading', `banned_by`='Console' WHERE `username`='" .. sql:escape_string(tostring(nick)) .. "'")
				if update then
					local ban = banPlayer(source, true, false, false, getRootElement(), "Ban Evading", 0)
				end	
				
				sql:free_result(update)
			else -- unban
				local update = sql:query("UPDATE `accounts` SET `banned`='0', `banned_by`=NULL, `banned_reason`=NULL WHERE `username`='" .. sql:escape_string(tostring(nick)) .. "'")
				sql:free_result(update)
				
				triggerEvent("attemptLogin", source, username, password )
			end	
		end
		
		if ( isElement(source) ) then 
			local update = sql:query("UPDATE `accounts` SET `ip`='".. getPlayerIP(source) .."' WHERE `username`='".. sql:escape_string(tostring(username)) .."'") -- Update their IP
			sql:free_result(update)
		end	
	else
		triggerClientEvent(source, "showSignInMessage", source, "Invalid username/password!", 150)
	end
end
addEvent("attemptLogin", true)
addEventHandler("attemptLogin", getRootElement(), attemptLogin)
	
--------- [ Login ] ---------
function onRestart( res )
	
	for i, thePlayer in ipairs ( getElementsByType("player") ) do
		if getElementData( thePlayer, "loggedin") then
			triggerEvent("savePlayer", thePlayer)
			triggerEvent("onJoin", thePlayer)
			
			setElementPosition(thePlayer, 0, 0, 3)
			setElementAlpha(thePlayer, 0)
		end
	end	
end
addEventHandler("onResourceStart", resourceRoot, onRestart)	

function onJoin( )
	for key, value in pairs(getAllElementData(source)) do
		removeElementData(source, key)
	end
	exports['[ars]global']:updateNametagColor( source )
	setPlayerNametagShowing( source, false )
end
addEvent("onJoin", true)
addEventHandler("onJoin", getRootElement(), onJoin)
addEventHandler("onPlayerJoin", getRootElement(), onJoin)

function setGameMode( )
      setGameType("Roleplay")
      setMapName("Los Santos")
end
addEventHandler("onResourceStart", resourceRoot, setGameMode)