--------- [ Animation System ] ---------

-- /cover
addCommandHandler("cover",
	function( thePlayer )
		setPedAnimation( thePlayer, "ped", "duck_cower", -1, false, false, false)
	end, false, false
)	


-- /cpr 
addCommandHandler("cpr",
	function( thePlayer )
		setPedAnimation( thePlayer, "medic", "cpr", 8000, false, true, false )
	end, false, false
)

-- /wait
addCommandHandler("wait",
	function( thePlayer )
		setPedAnimation( thePlayer, "COP_AMBIENT", "Coplook_loop", -1, true, false, false )
	end, false, false
)

-- /think
addCommandHandler("think",
	function( thePlayer )
		setPedAnimation( thePlayer, "COP_AMBIENT", "Coplook_think", -1, true, false, false )
	end, false, false
)	

-- /lean
addCommandHandler("lean",
	function( thePlayer )
		setPedAnimation( thePlayer, "GANGS", "leanIDLE", -1, true, false, false )
	end, false, false
)

-- /idle
addCommandHandler("idle",
	function( thePlayer )
		setPedAnimation( thePlayer, "DEALER", "DEALER_IDLE_01", -1, true, false, false )
	end, false, false
)

-- /piss
addCommandHandler("piss",
	function( thePlayer )
		setPedAnimation( thePlayer, "PAULNMAC", "Piss_loop", -1, true, false, false )
	end, false, false
)	

-- /wank
addCommandHandler("wank",
	function( thePlayer )
		setPedAnimation( thePlayer, "PAULNMAC", "wank_loop", -1, true, false, false )
	end, false, false
)

-- /slapass
addCommandHandler("slapass",
	function( thePlayer )
		setPedAnimation( thePlayer, "SWEET", "sweet_ass_slap", 2000, true, false, false )
	end, false, false
)	

-- /fixcar
addCommandHandler("fixcar",
	function( thePlayer )
		setPedAnimation( thePlayer, "CAR", "Fixn_Car_loop", -1, true, false, false )
	end, false, false
)

-- /handsup
addCommandHandler("handsup",
	function( thePlayer )
		setPedAnimation( thePlayer, "ped", "handsup", -1, false, false, false )
	end, false, false
)	

-- /hailtaxi 
addCommandHandler("hailtaxi",
	function( thePlayer )
		setPedAnimation( thePlayer, "MISC", "Hiker_Pose", -1, false, true, false )
	end, false, false
)	

-- /scratch
addCommandHandler("scratch",
	function( thePlayer )
		setPedAnimation( thePlayer, "MISC", "Scratchballs_01", -1, true, true, false )
	end, false, false
)	

-- /fu
addCommandHandler("fu",
	function( thePlayer )
		setPedAnimation( thePlayer, "RIOT", "RIOT_FUKU", 800, false, true, false )
	end, false, false
)

-- /strip
addCommandHandler("strip",
	function( thePlayer, commandName, id )
		
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "STRIP", "strip_A", -1, false, true, false )
		elseif ( id == 3 ) then
			setPedAnimation( thePlayer, "STRIP", "strip_B", -1, false, true, false )
		elseif ( id == 4 ) then
			setPedAnimation( thePlayer, "STRIP", "strip_C", -1, false, true, false )
		elseif ( id == 5 ) then
			setPedAnimation( thePlayer, "STRIP", "strip_D", -1, false, true, false )
		elseif ( id == 6 ) then
			setPedAnimation( thePlayer, "STRIP", "strip_E", -1, false, true, false )
		elseif ( id == 7 ) then
			setPedAnimation( thePlayer, "STRIP", "strip_F", -1, false, true, false )
		elseif ( id == 8 ) then
			setPedAnimation( thePlayer, "STRIP", "strip_G", -1, false, true, false )
		elseif ( id == 9 ) then
			setPedAnimation( thePlayer, "STRIP", "STR_Loop_A", -1, false, true, false )
		elseif ( id == 10 ) then
			setPedAnimation( thePlayer, "STRIP", "STR_Loop_B", -1, false, true, false )
		elseif ( id == 11 ) then
			setPedAnimation( thePlayer, "STRIP", "STR_Loop_C", -1, false, true, false )
		else
			setPedAnimation( thePlayer, "STRIP", "PUN_HOLLER", -1, false, true, false )
		end
	end, false, false
)

-- /drink
addCommandHandler("drink",
	function( thePlayer )
		setPedAnimation( thePlayer, "BAR", "dnk_stndM_loop", 2300, false, false, false )
	end, false, false
)

-- /lay
addCommandHandler("lay",
	function( thePlayer, commandName, id )
		
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "BEACH", "sitnwait_Loop_W", -1, true, false, false )
		else
			setPedAnimation( thePlayer, "BEACH", "Lay_Bac_Loop", -1, true, false, false )
		end
	end, false, false
)	

-- /beg
addCommandHandler("beg",
	function( thePlayer )
		setPedAnimation( thePlayer, "SHOP", "SHP_Rob_React", 4000, true, false, false )
	end, false, false
)

-- /mourn
addCommandHandler("mourn",
	function( thePlayer )
		setPedAnimation( thePlayer, "GRAVEYARD", "mrnM_loop", -1, true, false, false)
	end, false, false
)

-- /cry
addCommandHandler("cry",
	function( thePlayer )
		setPedAnimation( thePlayer, "GRAVEYARD", "mrnF_loop", -1, true, false, false)
	end, false, false
)

-- /cheer
addCommandHandler("cheer",
	function( thePlayer, commandName, id )
		
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "OTB", "wtchrace_win", -1, true, false, false )
		elseif ( id == 3 ) then
			setPedAnimation( thePlayer, "RIOT", "RIOT_shout", -1, true, false, false )
		else
			setPedAnimation( thePlayer, "STRIP", "PUN_HOLLER", -1, true, false, false )
		end
	end, false, false
)

-- /dance
addCommandHandler("dance",
	function( thePlayer, commandName, id )
		
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "DANCING", "dance_loop", -1, true, false, false )
		elseif ( id == 3 ) then
			setPedAnimation( thePlayer, "DANCING", "DAN_Down_A", -1, true, false, false )
		elseif ( id == 4 ) then
			setPedAnimation( thePlayer, "DANCING", "DAN_Loop_A", -1, true, false, false )
		elseif ( id == 5 ) then
			setPedAnimation( thePlayer, "DANCING", "DAN_Right_A", -1, true, false, false )
		elseif ( id == 6 ) then
			setPedAnimation( thePlayer, "DANCING", "DAN_Up_A", -1, true, false, false )
		elseif ( id == 7 ) then
			setPedAnimation( thePlayer, "DANCING", "dnce_M_a", -1, true, false, false )
		elseif ( id == 8 ) then
			setPedAnimation( thePlayer, "DANCING", "dnce_M_b", -1, true, false, false )
		else
			setPedAnimation( thePlayer, "DANCING", "DAN_Left_A", -1, true, false, false )
		end
	end, false, false
)

-- /crack
addCommandHandler("crack",
	function( thePlayer, commadName, id )
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "CRACK", "crckidle1", -1, true, false, false)
		elseif ( id == 3 ) then
			setPedAnimation( thePlayer, "CRACK", "crckidle3", -1, true, false, false)
		elseif ( id == 4 ) then
			setPedAnimation( thePlayer, "CRACK", "crckidle4", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "CRACK", "crckidle2", -1, true, false, false)
		end
	end, false, false
)	

-- /gsign
addCommandHandler("gsign",
	function( thePlayer, commadName, id )
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation(thePlayer, "GHANDS", "gsign2", 4000, true, false, false)
		elseif ( id == 3 ) then
			setPedAnimation(thePlayer, "GHANDS", "gsign3", 4000, true, false, false)
		elseif ( id == 4 ) then
			setPedAnimation(thePlayer, "GHANDS", "gsign4", 4000, true, false, false)
		elseif ( id == 5 ) then
			setPedAnimation(thePlayer, "GHANDS", "gsign5", 4000, true, false, false)
		else
			setPedAnimation(thePlayer, "GHANDS", "gsign1", 4000, true, false, false)
		end
	end, false, false
)

-- /puke
addCommandHandler("puke",
	function( thePlayer )
		setPedAnimation( thePlayer, "FOOD", "EAT_Vomit_P", 8000, true, false, false )
	end, false, false
)

-- /rap
addCommandHandler("rap",
	function( thePlayer, commandName, id )
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "LOWRIDER", "RAP_B_Loop", -1, true, false, false)
		elseif ( id == 3 ) then
			setPedAnimation( thePlayer, "LOWRIDER", "RAP_C_Loop", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "LOWRIDER", "RAP_A_Loop", -1, true, false, false)
		end
	end, false, false
)

-- /aim
addCommandHandler("aim",
	function( thePlayer )
		setPedAnimation(thePlayer, "SHOP", "ROB_Loop_Threat", -1, false, true, false)
	end, false, false
)

-- /sit
addCommandHandler("sit",
	function( thePlayer, commandName, id )
		local id = tonumber( id )
		if ( isPedInVehicle( thePlayer ) ) then
			if ( id == 2 ) then
				setPedAnimation( thePlayer, "CAR", "Sit_relaxed" )
			else
				setPedAnimation( thePlayer, "CAR", "Tap_hand" )
			end
		else
			if ( id == 2 ) then
				setPedAnimation( thePlayer, "FOOD", "FF_Sit_Look", -1, true, false, false)
			elseif ( id == 3 ) then
				setPedAnimation( thePlayer, "Attractors", "Stepsit_loop", -1, true, false, false)
			elseif ( id == 4 ) then
				setPedAnimation( thePlayer, "BEACH", "ParkSit_W_loop", 1, true, false, false)
			elseif ( id == 5 ) then
				setPedAnimation( thePlayer, "BEACH", "ParkSit_M_loop", 1, true, false, false)
			else
				setPedAnimation( thePlayer, "ped", "SEAT_idle", -1, true, false, false)
			end
		end
	end, false, false
)

-- /smoke
addCommandHandler("smoke", 
	function( thePlayer, commandName, id )
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "SMOKING", "M_smkstnd_loop", -1, true, false, false)
		elseif ( id == 3 ) then
			setPedAnimation( thePlayer, "LOWRIDER", "M_smkstnd_loop", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "GANGS", "smkcig_prtl", -1, true, false, false)
		end
	end, false, false
)

-- /smokelean
addCommandHandler("smokelean",
	function( thePlayer )
		setPedAnimation(thePlayer, "LOWRIDER", "M_smklean_loop", -1, true, false, false)
	end, false, false
)

-- /laugh
addCommandHandler("laugh",
	function( thePlayer )
		setPedAnimation(thePlayer, "RAPPING", "Laugh_01", -1, true, false, false)
	end, false, false
)

-- /carchat
addCommandHandler("carchat", 
	function( thePlayer )
		setPedAnimation(thePlayer, "CAR_CHAT", "car_talkm_loop", -1, true, false, false)
	end, false, false
)

-- /tired
addCommandHandler("tired",
	function( thePlayer )
		setPedAnimation(thePlayer, "FAT", "idle_tired", -1, true, false, false)
	end, false, false
)

-- /bitchslap
addCommandHandler("bitchslap",
	function( thePlayer )
		setPedAnimation(thePlayer, "MISC", "bitchslap", -1, true, false, false)
	end, false, false
)

-- /shocked
addCommandHandler("shocked",
	function( thePlayer )
		setPedAnimation(thePlayer, "ON_LOOKERS", "panic_loop", -1, true, false, false)
	end, false, false
)	

-- /dive
addCommandHandler("dive",
	function( thePlayer )
		setPedAnimation(thePlayer, "ped", "EV_dive", -1, false, true, false)
	end, false, false
)

-- /what Amination
addCommandHandler("what",
	function( thePlayer )
		setPedAnimation( thePlayer, "RIOT", "RIOT_ANGRY", -1, true, false, false)
	end, false, false
)

-- /fallfront
addCommandHandler("fallfront",
	function( thePlayer )
		setPedAnimation( thePlayer, "ped", "FLOOR_hit_f", -1, false, false, false)
	end, false, false
)

-- /fall
addCommandHandler("fall",
	function( thePlayer )
		setPedAnimation( thePlayer, "ped", "FLOOR_hit", -1, false, false, false)
	end, false, false
)

-- /walk
local walk = {
	"WALK_armed", "WALK_civi", "WALK_csaw", "Walk_DoorPartial", "WALK_drunk", "WALK_fat", "WALK_fatold", "WALK_gang1", "WALK_gang2", "WALK_old",
	"WALK_player", "WALK_rocket", "WALK_shuffle", "Walk_Wuzi", "woman_run", "WOMAN_runbusy", "WOMAN_runfatold", "woman_runpanic", "WOMAN_runsexy", "WOMAN_walkbusy",
	"WOMAN_walkfatold", "WOMAN_walknorm", "WOMAN_walkold", "WOMAN_walkpro", "WOMAN_walksexy", "WOMAN_walkshop", "run_1armed", "run_armed", "run_civi", "run_csaw",
	"run_fat", "run_fatold", "run_gang1", "run_old", "run_player", "run_rocket", "Run_Wuzi"
}

addCommandHandler("walk",
	function( thePlayer, command, id )
		
		local id = tonumber( id )
		if ( not walk[id] ) then
			id = 2
		end
			
		setPedAnimation( thePlayer, "PED", walk[id], -1, true, true, false)
	end, false, false	
)

-- /win
addCommandHandler("win",
	function( thePlayer, command, id )
		
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "CASINO", "manwinb", 2000, false, false, false)
		elseif ( id == 3 ) then
			setPedAnimation( thePlayer, "benchpress", "gym_bp_celebrate", 2000, false, false, false)
		else
			setPedAnimation( thePlayer, "CASINO", "manwind", 2000, false, false, false)
		end
	end, false, false
)

-- /daps
addCommandHandler("daps", 
	function( thePlayer, command, id )
		
		local id = tonumber( id )
		if ( id == 2 ) then
			setPedAnimation( thePlayer, "GANGS", "hndshkca", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "GANGS", "hndshkfa", -1, true, false, false)
		end
	end, false, false
)	

-- /givedaps
addCommandHandler("givedaps", 
	function( thePlayer, command, partialPlayerName )
		if (partialPlayerName) then
			local foundPlayer = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			if foundPlayer then
				local targX, targY, targZ = getElementPosition( foundPlayer )
				local x, y, z = getElementPosition( thePlayer )
				
				if ( getDistanceBetweenPoints3D( x, y, z, targX, targY, targZ ) < 2 ) then 
					
					setPedAnimation( thePlayer, "GANGS", "hndshkfa", -1, false, false, false)
					setPedAnimation( foundPlayer, "GANGS", "hndshkfa", -1, false, false, false)
				else
					outputChatBox("You are too far away from ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 0, 0)
				end	
			end
		else
			outputChatBox("SYNTAX: /".. command .." [ Player Name/ID ]", thePlayer, 212, 156, 49)
		end
	end, false, false
)	

--------- [ Binds ] ---------
function stopAnimation(thePlayer)
	setPedAnimation(thePlayer)
end

addEventHandler("onResourceStart", resourceRoot,
	function( res )
		for key, value in ipairs ( getElementsByType("player") ) do
			bindKey(value, "space", "down", stopAnimation)
		end	
	end
)

addEventHandler("onPlayerJoin", root,
	function( res )
		bindKey(source, "space", "down", stopAnimation)
	end
)