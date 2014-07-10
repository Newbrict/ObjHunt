include( "shared.lua" )

--[ Prop Updates ]--
net.Receive( "Prop update", function( length ) 
	local tHitboxMax = net.ReadVector()
	local tHitboxMin = net.ReadVector()
	LocalPlayer():SetHull( tHitboxMin, tHitboxMax )
	LocalPlayer():SetHullDuck( tHitboxMin, tHitboxMax )

	LocalPlayer().chosenProp = net.ReadEntity()
	print( "CLASS ON CLIENT->"..LocalPlayer().chosenProp:GetClass() )
	LocalPlayer().lastPropChange = net.ReadUInt(32)

	local propHeight = tHitboxMax.z - tHitboxMin.z
	LocalPlayer().propHeight = propHeight
end )

net.Receive( "Reset Prop", function( length, client ) 
	LocalPlayer().chosenProp = nil
	LocalPlayer():ResetHull()
	LocalPlayer().propHeight = 70
end )

-- probably remove this later.
net.Receive( "Prop Initialize", function( length, client ) 
	LocalPlayer().chosenProp = net.ReadEntity()
	LocalPlayer().propHeight = 70
end )
