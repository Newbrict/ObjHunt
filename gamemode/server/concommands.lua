-- for testing purposes

concommand.Add( "pain", function( ply,_,amt )
	ply:SetHealth( ply:Health() - amt[1] )
	print( "ply's hp is:".. ply:Health() )
end )

concommand.Add( "stuck", function( ply,_,amt )
	local ss = isStuck(ply)
	print ( ss )
end )
