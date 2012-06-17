local tajirigate = createObject(2911, 1950.65625,-2433.5595703125,12.512000083923, 0, 0, 0)
setElementInterior (tajirigate, 2)
setElementDimension (tajirigate, 97)

local tajiriopen = false

function opentajirigate(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local distance1 = getDistanceBetweenPoints3D(1950.65625,-2433.5595703125,12.512000083923, x, y, z)

	if (distance1<=5) and (tajiriopen==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 2, 97) then
			tajiriopen = true
			moveObject(tajirigate, 500, 1950.65625,-2433.5595703125,12.512000083923, 0, 0, 90)
			setTimer(closetajirigate, 3000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", opentajirigate)

function closetajirigate(thePlayer)
	if (tajiriopen==true) then
		moveObject(tajirigate, 500, 1950.65625,-2433.5595703125,12.512000083923, 0, 0, -90)
		setTimer (setOpen, 500, 1)
	end
end

function setOpen ()
	tajiriopen = false
end