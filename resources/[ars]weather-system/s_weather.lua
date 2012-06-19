local weathers = 
{
	{ 0, "Sunny 1" },
	{ 1, "Sunny 2" },
	{ 2, "Sunny 3" },
	{ 3, "Sunny 4" },
	{ 7, "Sunny 5" },
	{ 11, "Sunny 6" },
	{ 8, "Rainy" },
	{ 10, "Clear" },
	{ 9, "Fog" },
}

-- CHANGE WEATHER
local nextWeather = nil
function regulateWeather( )
	if ( nextWeather ~= nil ) then
		setWeather( nextWeather[1] )
		setNextWeather( )
	else
		setNextWeather( )
		regulateWeather( )
	end
end
addEventHandler("onResourceStart", resourceRoot, regulateWeather)
setTimer( regulateWeather, 3600000, 0 )

-- NEXT WEATHER
function setNextWeather( )
	nextWeather = weathers[math.random(1, #weathers)]
end

-- ADMIN COMMANDS
function adminSetWeather( thePlayer, commandName, givenWeatherID )
	if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (givenWeatherID) then
			
			local givenWeatherID = tonumber( givenWeatherID )
			local weather = weathers[givenWeatherID]
			if weather then
				setWeather(weather[1])
				setNextWeather()
				
				outputChatBox("The weather was set to '".. tostring(weather[2]) .."'.", thePlayer, 212, 156, 49)
			else
				for key, value in ipairs ( weathers ) do
					outputChatBox(tostring( key ) .." - ".. value[2], thePlayer, 212, 156, 49)
				end	
				
				outputChatBox("Weather ID can only be between 1 and " .. #weathers .. ".", thePlayer, 212, 156, 49)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Weather ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setweather", adminSetWeather, false, false)