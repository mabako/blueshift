--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:c_assignData( theElement, tostring(key), value )
	else
		return false
	end	
end

--------- [ Debugscript Security ] ---------
local exceptions = { }
exceptions["Phil"] = true
exceptions["Dev"] = true
exceptions.fxs = true

addEventHandler("onClientRender", root,
	function( )
		if ( isDebugViewActive( ) ) then
			
			local username = tostring( getData( localPlayer, "accountname" ) )
			if ( username == nil ) then	
				
				triggerServerEvent("remoteKick", localPlayer, "Unauthorized Command")
			else	
				if not exceptions[tostring(username)] then
					triggerServerEvent("remoteKick", localPlayer, "Unauthorized Command")
				end
			end	
		end
	end
)	