surface.CreateFont( "ScoreboardObjHunt",
{
	font		= "Helvetica",
	size		= 22,
	weight		= 800
})

surface.CreateFont( "ScoreboardObjHuntTitle",
{
	font		= "Helvetica",
	size		= 32,
	weight		= 800
})
--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = 
{
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar = vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )		

		self.Name		= self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetFont( "ScoreboardObjHunt" )
		self.Name:DockMargin( 8, 0, 0, 0 )

		self.Mute		= self:Add( "DImageButton" )
		self.Mute:SetSize( 32, 32 )
		self.Mute:Dock( RIGHT )

		self.Ping		= self:Add( "DLabel" )
		self.Ping:Dock( RIGHT )
		self.Ping:SetWidth( 50 )
		self.Ping:SetFont( "ScoreboardObjHunt" )
		self.Ping:SetContentAlignment( 5 )

		self.Deaths		= self:Add( "DLabel" )
		self.Deaths:Dock( RIGHT )
		self.Deaths:SetWidth( 50 )
		self.Deaths:SetFont( "ScoreboardObjHunt" )
		self.Deaths:SetContentAlignment( 5 )

		self.Kills		= self:Add( "DLabel" )
		self.Kills:Dock( RIGHT )
		self.Kills:SetWidth( 50 )
		self.Kills:SetFont( "ScoreboardObjHunt" )
		self.Kills:SetContentAlignment( 5 )

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3*2 )
		self:DockMargin( 2, 0, 2, 2)
		
	end,
	
	Setup = function( self, pl )
		
		self.Player = pl

		self.Avatar:SetPlayer( pl )
		self.Name:SetText( pl:Nick() )

		self:Think(self )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) )then
			self:Remove()
			return
		end

		if ( self.NumKills == nil || self.NumKills != self.Player:Frags() ) then
			self.NumKills	=	self.Player:Frags()
			self.Kills:SetText( self.NumKills )
		end

		if ( self.NumDeaths == nil || self.NumDeaths != self.Player:Deaths() ) then
			self.NumDeaths	=	self.Player:Deaths()
			self.Deaths:SetText( self.NumDeaths )
		end

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			self.NumPing	=	self.Player:Ping()
			self.Ping:SetText( self.NumPing )
		end

		--
		-- Change the icon of the mute button based on state
		--
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end
		
		--
		-- Connecting players go at the very bottom
		--
		/*
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 )
		end
		*/
		--
		-- This is what sorts the list. The panels are docked in the z order, 
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos( -(self.Player:Team()*100) +
		(
			self.NumKills * -50) +
			self.NumDeaths +
			math.min(string.byte(self.Player:Nick(), -1)/2, 99)
		)
	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end

		--
		-- We draw our background a different colour based on the status of the player
		--
		if ( self.Player:Team() == 1) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 0, 0, 127 ) )
			return
		end
		if ( self.Player:Team() == 2) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 255, 127 ) )
			return
		end

		-- all other teams
		draw.RoundedBox( 4, 0, 0, w, h, Color( 127, 127, 127, 127 ) )
		return

	end,
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" )

local HUNTERS_BOARD = 
{
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 50 )
		
		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ScoreboardObjHuntTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		
		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "ScoreboardObjHunt" )
		--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )

		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL)//fill

	end,

	PerformLayout = function( self )
		
		self:SetSize(ScrW()/4, ScrH() - 200 )
		self:Dock(LEFT)
		self:DockMargin(ScrW()/4-100,ScrH()/7,0,0)
		
	end,

	/*Paint = function( self, w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

	end,*/

	Think = function( self, w, h )

		self.Name:SetText("Hunters")

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		
		for id, pl in pairs( plyrs ) do
		
		if(pl:Team()==TEAM_HUNTERS) then
			
			if ( IsValid( pl.ScoreEntry ) ) then continue end
			
			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )
			
			self.Scores:AddItem( pl.ScoreEntry )
		
		else if(IsValid(pl.ScoreEntry)) then
			
			if(pl.ScoreEntry:HasParent(self.Scores)) then
			
			pl.ScoreEntry:Remove()
		
			end
		end
		end
		end
	end,


}

HUNTERS_BOARD = vgui.RegisterTable( HUNTERS_BOARD, "EditablePanel" )

local PROPS_BOARD = 
{
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 50 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "ScoreboardObjHuntTitle" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		
		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "ScoreboardObjHunt" )
		--self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )

		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock(FILL)//fill

	end,

	PerformLayout = function( self )

		self:SetSize(ScrW()/4, ScrH() - 200 )
		self:Dock(RIGHT)
		self:DockMargin(0,ScrH()/7,ScrW()/4-100,0)
		
	end,

	/*Paint = function( self, w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

	end,*/

	Think = function( self, w, h )

		self.Name:SetText("Props")
		
		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		
		for id, pl in pairs( plyrs ) do
		
		if(pl:Team()==TEAM_PROPS) then
			
			if ( IsValid( pl.ScoreEntry ) ) then continue end
			
			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )
			
			self.Scores:AddItem( pl.ScoreEntry )
		
		else if(IsValid(pl.ScoreEntry)) then
		
			if(pl.ScoreEntry:HasParent(self.Scores)) then
		
			pl.ScoreEntry:Remove()
		
			end
		end
		end
		end
	end,

}

PROPS_BOARD = vgui.RegisterTable( PROPS_BOARD, "EditablePanel" )

local SPECS_BOARD =
{
	Init = function( self )
	
		self.Header=self:Add("Panel")
		self.Header:Dock(BOTTOM)
		self.Header:SetHeight(100)
		self.Header:SetWidth(200)
		
		self.Name=self.Header:Add("DLabel")
		self.Name:SetFont("ScoreboardObjHuntTitle")
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		
		
		self.Spec_Players=self.Header:Add("DLabel")
		self.Spec_Players:SetFont("ScoreboardObjHuntTitle")
		self.Spec_Players:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Spec_Players:Dock( BOTTOM)
		self.Spec_Players:SetHeight( 40 )
		self.Spec_Players:SetContentAlignment( 5 )
		self.Spec_Players:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		self.Spec_Players:DockMargin(-ScrW()/5,0,0,0)
	
	end,
	
	PerformLayout = function( self )

		self:SetSize(ScrW()/3, ScrH()/2)
		self:Dock(BOTTOM)
		self:DockMargin(-ScrW()/8+15,0,0,ScrH()/3)
		
	end,
	
	Think = function(self , w, h)
	
	self.Name:SetText("Spectators:")
	Spectators=""
	
	
	
	local plyrs=player.GetAll()
	
	for id, pl in pairs ( plyrs ) do
		
		if(pl:Team()==0||pl:Team()==1002) then
			
			if(Spectators:find(pl:Nick())==nil) then
		
			Spectators=Spectators..pl:Nick()..","
			
			else
			
			continue
			
			end
		
		else if(Spectators:find(pl:Nick())!=nil)  then
		
		Spectators:gsub(pl:Nick(),"")
		
		end
	
	end
	
	
	end
	self.Spec_Players:SetText(Spectators)
	end,
}
SPECS_BOARD = vgui.RegisterTable( SPECS_BOARD, "EditablePanel" )	
	
--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if ( !IsValid( h_Scoreboard )&& !IsValid(p_Scoreboard)&&!IsValid(s_Scoreboard)) then
		h_Scoreboard = vgui.CreateFromTable( HUNTERS_BOARD )
		p_Scoreboard = vgui.CreateFromTable( PROPS_BOARD )
		s_Scoreboard = vgui.CreateFromTable( SPECS_BOARD )
	end

	if ( IsValid( h_Scoreboard ) && IsValid(p_Scoreboard)) then
		h_Scoreboard:Show()
		h_Scoreboard:MakePopup()
		h_Scoreboard:SetKeyboardInputEnabled( false )
		
		p_Scoreboard:Show()
		p_Scoreboard:MakePopup()
		p_Scoreboard:SetKeyboardInputEnabled( false )
		
		s_Scoreboard:Show()
		s_Scoreboard:MakePopup()
		s_Scoreboard:SetKeyboardInputEnabled( false )
		s_Scoreboard:DrawOutlinedRect()
	end

end

--[[---------------------------------------------------------
   Name: GameMode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	if ( IsValid( h_Scoreboard ) && IsValid(p_Scoreboard)) then
		h_Scoreboard:Hide()
		p_Scoreboard:Hide()
		s_Scoreboard:Hide()
	end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end