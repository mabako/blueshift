function getServerTime( )
    local hour = getRealTime().hour
    local minute = getRealTime().minute
	
	triggerClientEvent(source, "setClientTime", source, hour - 1, minute + 24)
end
addEvent("getServerTime", true)
addEventHandler("getServerTime", root, getServerTime)

function setServerTime( )
	local hour = getRealTime().hour
    local minute = getRealTime().minute
	
	setMinuteDuration (60000)
    setTime(hour - 1, minute + 24)
end
addEventHandler("onResourceStart", resourceRoot, setServerTime)

setTimer(
	function( )
		setServerTime( )
	end, 300000, 0
)	