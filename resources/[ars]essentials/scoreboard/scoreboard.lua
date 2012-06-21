-- scoreboard test
--[[
function shuffle(t)
  local n = #t
 
  while n >= 2 do
	-- n is now the last pertinent index
	local k = math.random(n) -- 1 <= k <= n
	-- Quick swap
	t[n], t[k] = t[k], t[n]
	n = n - 1
  end
 
  return t
end

local count = 5
local function getElementsByType()
	local t = {}
	while #t < count do
		table.insert(t, #t+1)
	end
	return shuffle(t)
end

local function getPlayerPing(i)
	return i * 13
end

local function getElementData(i)
	return i
end

local function getPlayerName(i)
	return "derp" .. i
end

function getPlayerNametagColor(i)
	return 255-i, 0, i
end

bindKey('num_sub', 'down',
	function()
		count = count - 1
	end
)
]]
-------------- [ Scoreboard ] ---------------
local screenX, screenY = guiGetScreenSize()

local width, height = 300, 420
local x = (screenX/2) - (width/2)
local y = (screenY/2) - (height/2)

local logowidth, logoheight = 275, 275
local logox = (x/2) - (logowidth/2)
local logoy = (y/2) - (logoheight/2)

local isEventHandled = false
local page = 1

local function byIDs(a, b)
	return getElementData(a, "playerid") < getElementData(b, "playerid")
end

function renderPlayerList( )
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 200))
	
	local players = getElementsByType("player")
	table.sort(players, byIDs)
	
	dxDrawText("Blushift Gaming 1.0", x + 4, y + 403, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	local playersText = #players .." Player" .. (#players == 1 and "" or "s")
	dxDrawText(playersText, x + width - 4 - dxGetTextWidth(playersText, 1, "default-bold"), y + 403, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	
	dxDrawText("ID", x + 15, y + 13, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	dxDrawText("Player", x + 60, y + 13, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	dxDrawText("Ping", x + 250, y + 13, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	
	dxDrawLine(x, y + 30, x + 299, y + 30, tocolor(255, 255, 255, 150), 1)
	
	local yTxt = (screenY/2) - (height/2) + 35
	
	-- might of want to fix the page here
	local any = false
	while not any do
		for i = page * 12 - 11, math.min(page * 12 + 12, #players) do
			local v = players[i]
			any = true
			
			local name = tostring( getPlayerName(v):gsub("_", " ") )
			local id = tostring( getElementData(v, "playerid") )
			local ping = tostring( getPlayerPing(v) )
			local r, g, b = getPlayerNametagColor(v)
			
			if v == localPlayer then
				dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
			end	
				
			dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
			dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
			dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
	
			yTxt = yTxt + 15
		end
		
		if not any then
			if page == 1 then
				break
			else
				page = page - 1
			end
		end
	end
end

function scrollDown( )
	if (isEventHandled) then
		if (page+1) * 12 < #getElementsByType("player") then
			page = page + 1
		end
	end	
end

function scrollUp( )
	if (isEventHandled) then
		if page > 1 then
			
			page = page - 1
		end	
	end	
end

function drawPlayerList( )
	if getElementData(localPlayer, "loggedin") then
		if not (isEventHandled) then
			
			isEventHandled = true
			
			addEventHandler("onClientRender", getRootElement(), renderPlayerList)
			addEventHandler("onClientPlayerWeaponSwitch", root, cancelEvent)
		end
	end	
end

function removePlayerList( )
	if (isEventHandled) then
		
		isEventHandled = false
		removeEventHandler("onClientRender", getRootElement(), renderPlayerList)
		removeEventHandler("onClientPlayerWeaponSwitch", root, cancelEvent)
	end	
end

function bindKeysOnStart( )
	bindKey("tab", "down", drawPlayerList)
	bindKey("tab", "up", removePlayerList)
	
	bindKey("mouse_wheel_down", "down", scrollDown)
	bindKey("mouse_wheel_up", "down", scrollUp)
end
addEventHandler("onClientResourceStart", resourceRoot, bindKeysOnStart)	