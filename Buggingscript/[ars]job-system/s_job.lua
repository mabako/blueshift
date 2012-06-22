local sql = exports.sql

--------- [ Job System ] ---------
function setPlayerJob( job )
	local jobID = nil
	
	if (job == "Road Sweeper") then
		jobID = 1
	elseif (job == "Bus Driver") then
		jobID = 2	
	elseif (job == "Taxi Driver") then
		jobID = 3
	elseif (job == "Oil Transporter") then
		jobID = 4
	end

	local update = sql:query("UPDATE `characters` SET `job`=".. sql:escape_string(tonumber(jobID)) .." WHERE `id`=".. sql:escape_string(tonumber(getElementData(source, "dbid"))) .."")
	if (update) then
		
		setElementData(source, "job", tonumber(jobID), true)
		outputChatBox("You are now a ".. job ..".", source, 0, 255, 0)
	else
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("setPlayerJob", true)
addEventHandler("setPlayerJob", root, setPlayerJob)

function removePlayerJob( )
	
	local update = sql:query("UPDATE `characters` SET `job`='0' WHERE `id`=".. sql:escape_string(tonumber(getElementData(source, "dbid"))) .."")
	if (update) then
		
		setElementData(source, "job", 0, true)
		outputChatBox("You quit your job.", source, 0, 255, 0)
	else
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("removePlayerJob", true)
addEventHandler("removePlayerJob", root, removePlayerJob)	