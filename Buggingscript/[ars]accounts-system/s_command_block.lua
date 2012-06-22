addEventHandler( "onPlayerCommand", root,
	function( full )
		if not getElementData( source, "loggedin" ) then
			local command = gettok( full, 1, string.byte(" ") )
			if command == 'login' then
				-- okay, login is acceptable.
			elseif not isGuestAccount( getPlayerAccount( source ) ) then
				-- is logged in, so presumably has an account, thus we allow most easy commands.
				-- debugscript isn't here, as you'd be kicked anyway.
				local allowed = {logout = true, start = true, stop = true, restart = true, refresh = true, refreshall = true}
			else
				cancelEvent( )
			end
		end
	end
)
