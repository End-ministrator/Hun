global function Hun_Init

void function Hun_Init()
{
    thread Hun()
}

void function Hun()
{
    WaitFrame()
    if( GameRules_GetGameMode() == FD )
    {
        BoostStoreOpenCallback_Init()
        BoostStoreClosedCallback_Init()
    }
    ChatCommandCallback_Init()

    WaitFrame()
    HunMessage_Init()

    WaitFrame()
    if( !IsLobby() && !IsMenuLevel() )
    {
        HunSay_Init()
        HunDetection_Init()
        HunBoostStore_Init()
        WaitFrame()
        thread Hun_AutoCore()
    }
    HunCommand_Init()
}

void function Hun_AutoCore()
{
    while( true )
    {
        WaitFrame()
        entity player = GetLocalClientPlayer()
        if( !IsValid( player ) || !IsAlive( player ) ) 
            continue
        if( !player.IsTitan() )
            continue
        if( IsCoreChargeAvailable( player, player.GetTitanSoul() ) && GetTitanCharacterName( player ) == "vanguard" )
        {
            GetLocalClientPlayer().ClientCommand("+ability 1")
            wait 0.1
            GetLocalClientPlayer().ClientCommand("-ability 1")
        }
    }
}