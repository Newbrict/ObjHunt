if AUTOTAUNT_ENABLED then

	local function runAutoTaunter()
		local players = team.GetPlayers(TEAM_PROPS)
		local pRange = TAUNT_MAX_PITCH - TAUNT_MIN_PITCH

		--Render the Auto-taunt HUD

		for _,ply in pairs(players) do
			local taunt = table.Random( PROP_TAUNTS )

			if ply:Alive() && ply:Team() == TEAM_PROPS then
				if ply.lastTaunt != nil then
					local lastAutoTaunt = math.Round(CurTime() - ply.lastTaunt)

					--Check if the lastAutoTaunt exceeds the autoTauntInterval
					if (lastAutoTaunt > ply.autoTauntInterval) then
						--Send the Taunt to the player
						local pRange = TAUNT_MAX_PITCH - TAUNT_MIN_PITCH
						local pitch = math.random()*pRange + TAUNT_MIN_PITCH
						SendTaunt(ply, taunt, pitch )
					end
				end
			end
		end
	end

	function CreateAutoTauntTimer()
		timer.Create("AutoTauntTimer", 0.1, 0, runAutoTaunter)
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

end