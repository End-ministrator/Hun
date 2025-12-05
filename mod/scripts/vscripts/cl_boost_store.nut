global function HunBoostStore_Init
global function GetBoostStore
global function WaitUntilBoostStoreOpen
global function WaitUntilBoostStoreClose
global function PingBoostStore

const vector BOOST_STORE_ICON_SIZE = <96,96,0>
entity BoostStore = null

void function HunBoostStore_Init()
{
    AddCreateCallback("prop_script", Prop)
}

void function Prop(entity prop)
{
    if( prop.Minimap_GetCustomState() == eMinimapObject_prop_script.BOOST_STORE )
    	BoostStore = prop
}

entity function GetBoostStore()
{
    return BoostStore
}

void function WaitUntilBoostStoreOpen()
{
    while( !BoostStoreOpen() )
    {
        WaitFrame()
    }
}

void function WaitUntilBoostStoreClose()
{
    while( BoostStoreOpen() )
    {
        WaitFrame()
    }
}

void function PingBoostStore( entity prop )
{
	if( !IsValid(prop) )
		return
	prop.EndSignal( "OnDestroy" )

	float startTime = Time()
	float endTime = Time() + 10.0

	while( Time() < endTime )
	{
		var rui = CreateCockpitRui( $"ui/overhead_icon_ping.rpak" )
		RuiSetBool( rui, "isVisible", true )
		RuiSetFloat2( rui, "iconSize", BOOST_STORE_ICON_SIZE )
		RuiTrackFloat3( rui, "pos", prop, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "startFlyTime", startTime )
		RuiSetFloat( rui, "fadeTime", 1.75 )
		RuiSetFloat( rui, "duration", 0.5 )
		RuiSetFloat3( rui, "iconColor", TEAM_COLOR_YOU / 255.0 )
		RuiSetFloat( rui, "scale", 4.0 )
		wait 0.5
	}
}