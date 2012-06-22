--------- [ Debugscript Security ] ---------
local exceptions = { }
exceptions["Phil"] = true
exceptions["Dev"] = true
exceptions["fx.s"] = true

addEventHandler("onClientRender", root,
	function( )
		if ( isDebugViewActive( ) ) then
			local username = tostring( getElementData( localPlayer, "accountname" ) )
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