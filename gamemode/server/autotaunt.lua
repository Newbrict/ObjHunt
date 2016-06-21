
function GM:PlayerInitialSpawn( ply )
	ply.autoTauntInterval = OBJHUNT_AUTOTAUNT_INTERVAL + OBJHUNT_HIDE_TIME
end

local function runAutoTaunter()
	local players = team.GetPlayers(TEAM_PROPS)
	local pRange = TAUNT_MAX_PITCH - TAUNT_MIN_PITCH

    --Render the Auto-taunt HUD
--	hook.Run("AutoTauntHUDRerender")

	for _,ply in pairs(players) do
		local taunt = table.Random( PROP_TAUNTS )

        if ply:Alive() && ply:Team() == TEAM_PROPS then
            if ply.lastTaunt != nil && (CurTime() - ply.lastTaunt > ply.autoTauntInterval)  then
                local lastAutoTaunt = math.Round(CurTime() - ply.lastTaunt)

                --Check if the lastAutoTaunt exceeds the autoTauntInterval
                if (lastAutoTaunt > ply.autoTauntInterval) then
                    --Send the Taunt to the player
                    local pRange = TAUNT_MAX_PITCH - TAUNT_MIN_PITCH
                    local pitch = math.random()*pRange + TAUNT_MIN_PITCH
			        SendTaunt(ply, taunt, pitch )
                elseif (math.mod(lastAutoTaunt,  5) == 0) then
                    --Re-sync the connection 
                    net.Start( "AutoTaunt Update" )
                        net.WriteUInt( ply:EntIndex(), 8 )
                        net.WriteFloat( ply.lastTaunt )
                        net.WriteFloat( ply.autoTauntInterval )
	                net.Broadcast()
                end
		    end
        end
	end
end

--net.Receive( "Taunt Selection", function()
--	local taunt = net.ReadString()
--	local pitch = net.ReadUInt( 8 )
--	local id = net.ReadUInt( 8 )
--	local ply = player.GetByID( id )

--	if not IsValid( ply ) then return end

--	if( ply == LocalPlayer() ) then
--        local soundDur = SoundDuration( taunt ) * (100/pitch)
--        ply.autoTauntInterval = OBJHUNT_AUTOTAUNT_INTERVAL + soundDur
--		ply.lastTaunt = CurTime()
--        hook.Run("AutoTauntHUDRerender")

--        net.Start( "Update Taunt Times" )
--            net.WriteUInt( id, 8 )
--            net.WriteFloat( ply.nextTaunt )
--            net.WriteFloat( ply.lastTaunt )
--            net.WriteFloat( ply.autoTauntInterval )
--	    net.SendToServer()
--	end

--end )

function CreateAutoTauntTimer()
	timer.Create("AutoTauntTimer",.1,0,function () runAutoTaunter() end)
end

hook.Add( "Initialize", "Set Map Time",  function ()
	mapStartTime = os.time()
	CreateAutoTauntTimer()
end)

hook.Add("OBJHUNT_RoundStart", "Restart the Timer", function ()
	local players = team.GetPlayers(TEAM_PROPS)
	for _,ply in pairs(players) do

        ply.autoTauntInterval = OBJHUNT_AUTOTAUNT_INTERVAL + OBJHUNT_HIDE_TIME
		ply.lastTaunt = CurTime()

        net.Start( "AutoTaunt Update" )
            net.WriteUInt( ply:EntIndex(), 8 )
            net.WriteFloat( ply.lastTaunt )
            net.WriteFloat( ply.autoTauntInterval )
	    net.Broadcast()
	end

	if timer.Exists("AutoTauntTimer") then
		timer.Start("AutoTauntTimer")
	else
		CreateAutoTauntTimer()
	end
	
end)
