local function tauntSelection()
	PrintTable( TAUNTS )
end
net.Receive("Taunt Selection", tauntSelection)
