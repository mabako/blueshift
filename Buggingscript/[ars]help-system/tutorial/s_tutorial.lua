local sql = exports.sql

--------- [ Tutorial System ] ---------	
function saveTutorial( )
	local id = tonumber( getElementData(source, "accountid") )
	if ( id ) then
		
		local update = sql:query("UPDATE `accounts` SET `tutorial`='1' WHERE `id`=".. sql:escape_string( id ))
		if ( update ) then
			setElementData(source, "tutorial", true, false)
			triggerEvent("loginPlayer", source, false)
		end	
	end	
	
	sql:free_result(update)
end
addEvent("saveTutorial", true)
addEventHandler("saveTutorial", root, saveTutorial)