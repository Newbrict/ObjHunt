include( "shared.lua" )

--[ Prop Updates ]--
net.Receive( "Prop update", function( length ) 
	local tHitboxMax = net.ReadVector()
	local tHitboxMin = net.ReadVector()
	LocalPlayer():SetHull( tHitboxMin, tHitboxMax )
	LocalPlayer():SetHullDuck( tHitboxMin, tHitboxMax )

	LocalPlayer().chosenPropIndex = net.ReadUInt(8)
	LocalPlayer().lastPropChange = net.ReadUInt(32)

	local propHeight = tHitboxMax.z - tHitboxMin.z
	LocalPlayer().propHeight = propHeight

	-- INITIALIZATION STUFF GOES HERE, this only gets run once the player becomes a prop!
	if( !LocalPlayer().chosenProp ) then
		hook.Add( "OnEntityCreated", "Inital Prop Creation", function( ent )
    	    if ( LocalPlayer().chosenPropIndex and LocalPlayer().chosenPropIndex == ent:EntIndex() ) then
    	        LocalPlayer().chosenProp = ent
    	        LocalPlayer().lastPropChange = 0
    	        hook.Remove( "OnEntityCreated", "Get Player Prop" ) -- no longer needed, so remove it
    	    end
    	end )
	end

end )

net.Receive( "Reset Prop", function( length, client ) 
	LocalPlayer().chosenProp = nil
	LocalPlayer():ResetHull()
	LocalPlayer().propHeight = 70
end )


