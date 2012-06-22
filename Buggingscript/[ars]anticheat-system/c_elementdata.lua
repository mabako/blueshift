addEvent( "elementdata", true )
addEventHandler( "elementdata", root,
	function( key, value )
		-- set unsynched data
		setElementData( source, key, value, false )
	end
)
