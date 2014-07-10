include( "shared.lua" )

--[ Prop Updates ]--
net.Receive( "Prop update", function( length, client ) 
	local tHitboxMax = net.ReadVector()
	local tHitboxMin = net.ReadVector()
	LocalPlayer():SetHull( tHitboxMin, tHitboxMax )
	LocalPlayer():SetHullDuck( tHitboxMin, tHitboxMax )

	LocalPlayer().chosenProp = net.ReadEntity()
	LocalPlayer().lastPropChange = net.ReadUInt(32)

	local propHeight = tHitboxMax.z - tHitboxMin.z
	LocalPlayer().propHeight = propHeight
end )

net.Receive( "Reset Prop", function( length, client ) 
	LocalPlayer().chosenProp = nil
	LocalPlayer():ResetHull()
	LocalPlayer().propHeight = 70

end )
