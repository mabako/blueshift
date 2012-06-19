function setServerTime( )
	local hour = getRealTime().hour
	local minute = getRealTime().minute

	setMinuteDuration(60000)
	setTime(hour, minute)
end
addEventHandler("onResourceStart", resourceRoot, setServerTime)

setTimer(
	function( )
		setServerTime( )
	end, 300000, 0
)	