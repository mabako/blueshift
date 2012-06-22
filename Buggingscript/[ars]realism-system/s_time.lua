function setServerTime( )
	local hour = getRealTime().hour + (tonumber(get('time_offset')) or 5)
	if hour >= 24 then
		hour = hour - 24
	elseif hour < 0 then
		hour = hour + 24
	end
	
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