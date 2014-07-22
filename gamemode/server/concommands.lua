-- for testing purposes

concommand.Add( "pain", function( ply,_,amt )
	ply:SetHealth( ply:Health() - amt[1] )
	print( "ply's hp is:".. ply:Health() )
end )

concommand.Add( "stuck", function( ply,_,amt )
	local ss = isStuck(ply)
	print ( ss )
end )

concommand.Add( "SetBotTeam", function( ply )
	ply:AddFrags(5)
	local bots = player.GetBots()
	for id, bot in pairs( bots ) do
	bot:SetTeam(ply:Team())
	end
end )