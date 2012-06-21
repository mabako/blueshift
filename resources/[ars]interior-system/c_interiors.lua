--------- [ Interior System ] ---------

-- DRAW INTERIOR DETAILS
local rendering = false
local calibri = dxCreateFont("calibri.ttf", 11, true)

function drawInteriorDetails( )
	local a, b, c = getCameraMatrix( ) 
	
	for index, value in ipairs (getElementsByType("marker", resourceRoot, true)) do
		if tostring(getElementID(value)):sub(1, 4) == "int-" then
			local x, y, z = getElementPosition(value)
			local distance = getDistanceBetweenPoints3D(x, y, z, a, b, c)	
			
			if ( distance <= 15 ) then
			
				local screenX, screenY = getScreenFromWorldPosition(x, y, z + 1.5)
				if (screenX and screenY) then
					
					local sightClear = isLineOfSightClear( a, b, c, x, y, z + 0.75, true, true, false, false, false )
					if ( sightClear ) then
						
						local name = tostring(getElementData(value, "name"))
						local price = tonumber(getElementData(value, "price"))
						local owner = tonumber(getElementData(value, "owner"))
						local rented = tonumber(getElementData(value, "rented"))
						local type = tonumber(getElementData(value, "type"))
						local elevator = tonumber(getElementData(value, "elevator"))
					
						local helpText = nil
						
						if (owner == -1) and (type ~= 3) and (rented == 0) and (elevator == 0) then
							helpText = "Press F to buy"
							price = "Price: $".. tostring(price)
						elseif (owner == -1) and (type ~= 3) and (rented == 1) and (elevator == 0) then
							helpText = "Press F to rent"
							price = "Price: $".. tostring(price)
						elseif (owner > 0) and (type ~= 3) and (elevator == 1) then
							helpText = "Press F to enter"
							price = ""
						elseif (owner > 0) and (type ~= 3) and (elevator == 0) then
							helpText = "Press F to enter"
							price = ""	
						elseif (owner == -1) and (type ~= 3) and (elevator == 1) then
							helpText = ""
							price = ""	
						elseif (owner == -1) and (type == 3) then
							helpText = "Press F to enter"
							price = ""
						end	
						
						local r, g, b = 255, 255, 255
						
						if (calibri) then
							dxDrawText(tostring(name), screenX - 55, screenY - 5, screenX, screenY, tocolor(r, g, b, 200), 1, calibri, "center")
							dxDrawText(tostring(helpText), screenX - 55, screenY + 13, screenX, screenY + 18, tocolor(r, g, b, 200), 1, calibri, "center")
							dxDrawText(tostring(price), screenX - 55, screenY + 31, screenX, screenY + 36, tocolor(r, g, b, 200), 1, calibri, "center")
						end
					end
				end	
			end	
		end	
	end	
end

function renderInteriorDetails( )
	if ( not rendering ) then
		
		rendering = true
		addEventHandler("onClientRender", root, drawInteriorDetails)
	end	
end
addEvent("renderInteriorDetails", true)
addEventHandler("renderInteriorDetails", localPlayer, renderInteriorDetails)

addEventHandler("onClientResourceStart", resourceRoot,
	function( )
		if getElementData( localPlayer, "loggedin" ) then
			
			rendering = true
			addEventHandler("onClientRender", root, drawInteriorDetails)
		end
	end
)	