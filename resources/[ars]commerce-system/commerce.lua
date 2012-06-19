local sql = exports.sql

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value, sync )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

--------- [ Commerce System ] ---------

-- /sell
function sell( thePlayer, commandName, partialPlayerName )
	if (partialPlayerName) then
		
		local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
		if #players == 0 then
			outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
		elseif #players > 1 then
			outputChatBox("Multiple Players found!", thePlayer, 255, 200, 0)
				
			local count = 0
			for k, foundPlayer in ipairs (players) do
					
				count = count + 1
				outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
			end		
		else
			for k, foundPlayer in ipairs (players) do
				
				if ( foundPlayer ~= thePlayer ) then
					
					local sellerID = tonumber( getData( thePlayer, "dbid" ) )
					local buyerID = tonumber( getData( foundPlayer, "dbid" ) )	
				
					local vehicle = getPedOccupiedVehicle( thePlayer )
					if ( isElement( vehicle ) ) then
						
						local vehicleID = tonumber( getData( vehicle, "dbid" ) )
						local vehicleOwner = tonumber( getData( vehicle, "owner" ) )
						
						if ( sellerID == vehicleOwner ) or ( exports['[ars]global']:isPlayerAdministrator( thePlayer ) ) then
							
							local update = sql:query("UPDATE `vehicles` SET `owner`=".. sql:escape_string( buyerID ) .." WHERE `id`=".. sql:escape_string( vehicleID ))
							if ( update ) then
								
								setData( vehicle, "owner", buyerID, true)
								
								-- Journey
								if ( getElementModel( vehicle ) == 508 ) then
									local t = getAttachedElements( vehicle )
									if ( #t == 1 ) then
										
										local trailer = nil
										for key, value in ipairs ( t ) do
											trailer = value
											break
										end
										
										if ( getElementType( trailer ) == "marker" ) then
											
											local child = getElementChild( trailer, 0 )
											outputDebugString("setting..")
											setData( trailer, "owner", buyerID, true)
											setData( child, "owner", buyerID, true)
										end	
									end
								end	
								
								exports['[ars]inventory-system']:giveItem( foundPlayer, 1, tostring( vehicleID ) )
								
								if ( sellerID == vehicleOwner ) then
									exports['[ars]inventory-system']:takeItem( thePlayer, 1, tostring( vehicleID ) )
								end	
							
								outputChatBox("You sold this ".. getVehicleName(vehicle) .." to ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 0, 255, 0)
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." sold you his ".. getVehicleName(vehicle) ..".", foundPlayer, 0, 255, 0)
							else
								outputDebugString("MySQL Error: Unable to sell vehicle!")
								outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
							end
							
							sql:free_result(update)
						else
							outputChatBox("You do not own this vehicle.", thePlayer, 255, 0, 0)
						end
					elseif ( getElementInterior( thePlayer ) > 0 and getElementDimension( thePlayer ) > 0 ) then
						
						local dbid = getElementDimension( thePlayer )
						local interior = nil
						for key, value in ipairs (getElementsByType("marker")) do
							if ( getElementDimension( value ) == dbid and isElement( getElementParent(value) ) ) then
								
								local elevator = tonumber(getData(value, "elevator"))
								if ( elevator == 0 ) then
									
									interior = value
									break
								end	
							end
						end	
			
						local type = tonumber( getData(interior, "type") )
						if ( type ~= 3 ) then
			
							local propertyOwner = tonumber( getData(interior, "owner") )
							if ( propertyOwner == sellerID ) or ( exports['[ars]global']:isPlayerAdministrator( thePlayer ) ) then
								
								local update = sql:query("UPDATE `interiors` SET `owner`=".. sql:escape_string( buyerID ) .." WHERE `id`=".. sql:escape_string( dbid ) .."")
								if (update) then
								
									setData(interior, "owner", buyerID, true)
									
									local parent = getElementParent( interior )
									setData(parent, "owner", buyerID, true)
									
									-- Journey
									local journey = getElementAttachedTo( parent )
									if ( journey ) and ( getElementType( journey ) == "vehicle" ) then
										
										setData( journey, "owner", buyerID, true)
									end
									
									exports['[ars]inventory-system']:giveItem( foundPlayer, 2, tostring( dbid ) )
									
									if ( propertyOwner == sellerID ) then
										exports['[ars]inventory-system']:takeItem( thePlayer, 2, tostring( dbid ) )
									end	
									
									outputChatBox("You sold this property to ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 0, 255, 0)
									outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." sold you this property.", foundPlayer, 0, 255, 0)
								else
									outputDebugString("MySQL Error: Unable to sell property!")
									outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
								end
								
								sql:free_result(update)
							else
								outputChatBox("You do not own this property.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("You do not own this property.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("You need to use this command inside your vehicle/property.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("You cannot sell your vehicle/property to yourself.", thePlayer, 255, 0, 0)
				end
			end
		end
	else
		outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
	end
end
addCommandHandler("sell", sell, false, false)

-- /pay
function pay( thePlayer, commandName, partialPlayerName, amount )
	if (partialPlayerName) and (amount) then
		
		local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
		if #players == 0 then
			outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
		elseif #players > 1 then
			outputChatBox("Multiple Players found!", thePlayer, 255, 200, 0)
				
			local count = 0
			for k, foundPlayer in ipairs (players) do
					
				count = count + 1
				outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
			end		
		else
			for k, foundPlayer in ipairs (players) do
				
				if ( foundPlayer ~= thePlayer ) then
					
					local x, y, z = getElementPosition(thePlayer)
					local pX, pY, pZ = getElementPosition(foundPlayer)
					
					if (getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ) <= 10) then
						
						local amount = tonumber( amount )
						if ( amount > 0 ) then
						
							local money = tonumber( getPlayerMoney( thePlayer )/100 )
							
							if ( amount <= money ) then
								
								local faction = tonumber( getData( foundPlayer, "faction" ) )
								local duty = tonumber( getData( foundPlayer, "duty" ) )
								if ( faction == 4 and duty == 1 ) then
									
									takePlayerMoney(thePlayer, amount*100)
									triggerEvent( "giveMoneyToVs", foundPlayer, amount )
									
									outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." paid you $".. tostring( amount ) .." for the services.", foundPlayer, 212, 156, 49)
								else	
									givePlayerMoney(foundPlayer, amount*100)
									takePlayerMoney(thePlayer, amount*100)
									
									outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." gave you $".. tostring( amount ) ..".", foundPlayer, 212, 156, 49)
								end	
								
								outputChatBox("You gave $".. tostring( amount ) .." to ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
							end
						else
							outputChatBox("You cannot pay less than $0.01.", thePlayer, 255, 0, 0)
						end	
					else
						outputChatBox("You are too far away from ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("You cannot pay yourself.", thePlayer, 255, 0, 0)
				end	
			end
		end
	else
		outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Amount]", thePlayer, 212, 156, 49)
	end
end
addCommandHandler("pay", pay, false, false)