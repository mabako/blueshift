local sql = exports.sql

--------- [ Tutorial System ] ---------	
function saveTutorial( )
	local id = tonumber( getElementData(source, "accountid") )
	if ( id ) then
		
		local update = sql:query("UPDATE `accounts` SET `tutorial`='1' WHERE `id`=".. sql:escape_string( id ))
		if ( update ) then
			
			local username = tostring( getElementData(source, "accountname") )
			local admin = tonumber( getElementData(source, "admin") )
			local adminduty = tonumber( getElementData(source, "adminduty") )
			local hiddenadmin = tonumber( getElementData(source, "hiddenadmin") )
			local reports = tonumber( getElementData(source, "adminreports") )
			local donator = tonumber( getElementData(source, "donator") )
			local togglepm = tonumber( getElementData(source, "togglepm") )
			local tutorial = 1
			local friends = tostring( getElementData(source, "friends") )
			local skinmods = tonumber( getElementData(source, "skinmods") )
			local weaponmods = tonumber( getElementData(source, "weaponmods") )
			local vehiclemods = tonumber( getElementData(source, "vehiclemods") )
		
			triggerEvent("loginPlayer", source, username, id, admin, adminduty, hiddenadmin, reports, donator, togglepm, tutorial, friends, skinmods, weaponmods, vehiclemods, false)
		end	
	end	
	
	sql:free_result(update)
end
addEvent("saveTutorial", true)
addEventHandler("saveTutorial", root, saveTutorial)