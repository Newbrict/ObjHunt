function runAutoTaunter()
	local players = team.GetPlayers(TEAM_PROPS)
	local pRange = TAUNT_MAX_PITCH - TAUNT_MIN_PITCH

    --Render the Auto-taunt HUD
--	hook.Run("AutoTauntHUDRerender")

	for _,ply in pairs(players) do
		local taunt = table.Random( PROP_TAUNTS )

        if ply:Alive() && ply:Team() == TEAM_PROPS then
            if ply.lastTauntTime != nil && (CurTime() - ply.lastTauntTime > OBJHUNT_AUTOTAUNT_INTERVAL)  then
			    SendTaunt(ply, taunt, math.random()*pRange + TAUNT_MIN_PITCH )
		    end
        end
	end
	
end
