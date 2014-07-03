local function taunt_selection()
	local t_form = vgui.Create( "DFrame" ) -- works here not in play_hunter?????
	t_form:SetPos( ScrW() / 2 - 200, ScrH() / 2 - 50 ) -- Position form on your monitor
	t_form:SetTitle( "PLay a taunt!" )
	t_form:SetSize( 320,395) 		  -- Size form
	t_form:SetVisible( true ) 		  -- Form rendered ( true or false )
	t_form:SetDraggable( false ) 	  -- Form draggable
	t_form:ShowCloseButton( true )   -- Show buttons panel
	t_form.btnMaxim:Hide()
	t_form.btnMinim:Hide()
	t_form:MakePopup()

	local PlayBtn = vgui.Create( "DButton" )
	PlayBtn:SetParent( t_form )
	PlayBtn:SetPos( 10, 35 )
	PlayBtn:SetText( "PLay" )
	PlayBtn:SetSize( 100, 30 )

	PlayBtn.DoClick = function()
		sound.Play("vo/npc/female01/yeah02.wav", LocalPlayer():GetPos(), 75, 100, 1)
	end

-------------------------------------------------------------------------------------------------------

	local PlaySelectedBtn = vgui.Create( "DButton" )
	PlaySelectedBtn:SetParent( t_form )
	PlaySelectedBtn:SetPos( 120, 35 )
	PlaySelectedBtn:SetText( "Play s" )
	PlaySelectedBtn:SetSize( 100, 30 )

	PlaySelectedBtn.DoClick = function()
		sound.Play("sounds/taunt_sounds/aliens_game_over.wav", LocalPlayer():GetPos(), 75, 100, 1)
	end

	local SoundList = vgui.Create("DListView")
	SoundList:SetParent( t_form )
	SoundList:SetMultiSelect(false)
	SoundList:SetPos( 10, 70)
	SoundList:SetSize( 300, 310 )
	SoundList:AddColumn("Sounds")

	--SoundList:AddLine( "love_runs_out" )
	--SoundList:AddLine( "aliens_game_over" )
	file.Find( "*", "GAME" )


	local soundFiles, _ = file.Find( "gamemodes/ObjHunt/gamemode/player_class/*", "MOD" ) --"gamemodes/ObjHunt/content/sounds/*"
	print(soundFiles[1])
	for _, soundFile in ipairs(soundFiles) do
		SoundList:AddLine( "soundFile" )
		print(soundFiles[1])
	end

end
usermessage.Hook("taunt_selection", taunt_selection)
