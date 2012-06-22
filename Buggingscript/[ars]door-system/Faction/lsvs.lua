local doors = { }
doors[1] = createObject(3089, -2092.3999, -237.3999, 1029.1199, 0, 0, 0)

for key, door in ipairs ( doors ) do
	setElementInterior( door, 3 )
	setElementDimension( door, 61 ) 
end	

local open = false
addCommandHandler("gate",
	function( thePlayer, commandName )
	
		local x, y, z = getElementPosition(thePlayer)
		local dx, dy, dz = getElementPosition( doors[1] )
		
		local distance = getDistanceBetweenPoints3D(dx, dy, dz, x, y, z)

		if (distance <= 5) and ( not open ) then
			
			if ( exports['[ars]inventory-system']:hasItem( thePlayer, 35 ) ) then
				
				open = true
				moveObject(doors[1], 500, -2092.3999, -237.3999, 1029.1199, 0, 0, 90)
				
				setTimer( 
					function( )
						
						open = false
						moveObject(doors[1], 500, -2092.3999, -237.3999, 1029.1199, 0, 0, -90)
					end, 2000, 1
				)	
			end
		end
	end, false, false
)	

local objGatec = createObject(10671, 2812.6376953125, -1468.373046875, 17.148530960083, 0, 0, 88.978271484375)
local open = false
 
-- Gate code
function useImpoundDoorc(thePlayer)
        local team = getPlayerTeam(thePlayer)
        if ( exports['[ars]inventory-system']:hasItem( thePlayer, 35 ) ) then
                local x, y, z = getElementPosition(thePlayer)
                local distance = getDistanceBetweenPoints3D(2812.6376953125, -1468.373046875, 17.148530960083, x, y, z)
 
                if (distance<=15) and (open==false) then
                        open = true
                        outputChatBox("The impound lot gate is now open!", thePlayer, 0, 255, 0)
                        moveObject(objGatec, 1000, 2812.6259765625, -1466.4775390625, 18.799030303955, 0,90,0)
                        setTimer(closeImpoundDoorc, 5000, 1, thePlayer)
                end
        end
end
addCommandHandler("gate", useImpoundDoorc)
 
function closeImpoundDoorc(thePlayer)
        moveObject(objGatec, 1000, 2812.6376953125, -1468.373046875, 17.148530960083, 0, -90, 0)
        setTimer(resetState1c, 1000, 1)
end
 
 
function resetState1c()
        open = false
end