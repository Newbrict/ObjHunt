include( "shared.lua" )

--[ Prop Hull Updates ]--
net.Receive( "Hull Update", function( length, client ) 
	local tHitboxMax = net.ReadVector()
	local tHitboxMin = net.ReadVector()
	LocalPlayer():SetHull( tHitboxMin, tHitboxMax )
	LocalPlayer():SetHullDuck( tHitboxMin, tHitboxMax )
end )