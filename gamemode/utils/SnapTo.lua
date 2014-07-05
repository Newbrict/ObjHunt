//
// Snaps Angle to nearest... Josh 'Acecool' Moser
//
local META_ANGLE = FindMetaTable( "Angle" );
function META_ANGLE:SnapTo( _component, _snap_degrees )
	if ( _snap_degrees == 0 ) then ErrorNoHalt( "The snap degrees must be non-zero.\n" ); return self; end
	if ( !self[ _component ] ) then ErrorNoHalt( "You must choose a valid component of Angle( p || pitch, y || yaw, r || roll ) to snap such as Angle( 80, 40, 30 ):SnapTo( \"p\", 90 ):SnapTo( \"y\", 45 ):SnapTo( \"r\", 40 ); and yes, you can keep adding snaps.\n" ); return self; end

	self[ _component ] = math.Round( self[ _component ] / _snap_degrees ) * _snap_degrees;
	self[ _component ] = math.NormalizeAngle( self[ _component ] );

	return self;
end