
function create_time_panel( initial )
	--create intial time panel setup
	round_timer_form = vgui.Create( "DFrame" ) -- works here not in play_hunter?????
	round_timer_form :SetPos( ScrW() - 250, ScrH() - 150 ) -- Position form on your monitor
	round_timer_form :SetTitle( "Time left until next round" )
	round_timer_form :SetSize( 200,100 ) 		  -- Size form
	round_timer_form :SetVisible( true ) 		  -- Form rendered ( true or false )
	round_timer_form :SetDraggable( false ) 	  -- Form draggable
	round_timer_form :ShowCloseButton( false )   -- Show buttons panel
	round_timer_form .btnMaxim:Hide()
	round_timer_form .btnMinim:Hide()
	round_timer_form :MakePopup()
    time_lable = vgui.Create( "DLabel" )
	time_lable:SetParent(round_timer_form )
	time_lable:SetPos( 80, 30 )
	time_lable:SetSize( 150,50 )
	if( initial) then
		timer.Create( "ready_timer", 1, 10, function()  time_lable:SetText( timer.RepsLeft( "ready_timer") ) end )
		round_start=false--check if round has started
	end
end

function update_timer()
    if( !round_start and (!timer.Exists( "ready_timer" or timer.RepsLeft( "ready_timer" ) == 0 ) ) ) then
    	round_timer_form:SetTitle( "time left in round" )
    	timer.Create("round_timer", 1, 20, function() time_lable:SetText( timer.RepsLeft( "round_timer" ) ) end)--time of round
    	round_start=true

    elseif( round_start and (!timer.Exists( "round_timer" ) or timer.RepsLeft( "round_timer" ) == 0 ) ) then
    	timer.Create( "ready_timer", 1, 10, function()  time_lable:SetText( timer.RepsLeft( "ready_timer") ) end )--time in betweed rounds
    	round_start=false
    	round_timer_form :SetTitle( "Time left until next round" )
    	--have a switch team command here?
    end
  
end

usermessage.Hook( "create_time_panel", create_time_panel, inital )
usermessage.Hook("update_timer", update_timer)
	