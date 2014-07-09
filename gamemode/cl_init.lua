include( "shared.lua" )

--[ Prop Hull Updates ]--
net.Receive( "Prop update", function( length, client ) 
	local tHitboxMax = net.ReadVector()
	local tHitboxMin = net.ReadVector()
	LocalPlayer().chosenProp = net.ReadEntity()
	LocalPlayer().lastPropChange = net.ReadUInt(32)
	LocalPlayer():SetHull( tHitboxMin, tHitboxMax )
	LocalPlayer():SetHullDuck( tHitboxMin, tHitboxMax )
end )

net.Receive( "Reset Prop", function( length, client ) 
	LocalPlayer().chosenProp = nil
	LocalPlayer():ResetHull()
end )
