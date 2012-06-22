local coinzgate = createObject(1501, -89.658203125, 1438.62890625, 2119.7526855469, 0, 0, 270)
setElementInterior (coinzgate, 18)
setElementDimension (coinzgate, 110)

local coinzopen = false

function opencoinzgate(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local distance1 = getDistanceBetweenPoints3D(-89.658203125, 1438.62890625, 2119.7526855469, x, y, z)

	if (distance1<=5) and (coinzopen==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 2, 110) then
			coinzopen = true
			moveObject(coinzgate, 500, -89.658203125, 1438.62890625, 2119.7526855469, 0, 0, 90)
			setTimer(closecoinzgate, 2000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", opencoinzgate)

function closecoinzgate(thePlayer)
	if (coinzopen==true) then
		moveObject(coinzgate, 500, -89.658203125, 1438.62890625, 2119.7526855469, 0, 0, -90)
		coinzopen = false
	end
end
