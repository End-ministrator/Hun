global function HunDetection_Init

array<string> BoostStore

void function HunDetection_Init()
{
    if( GameRules_GetGameMode() != FD )
    {
        AddEventNotificationCallback( eEventNotifications.FD_BoughtItem, FD_BoughtItem )
        AddBoostStoreOpenCallback( BoostStoreOpenCallback )
        AddBoostStoreClosedCallback( BoostStoreClosedCallback )
    }
    thread GameStateEnterCallback_Init()
}

void function GameStateEnterCallback_Init()
{
    wait 1.0
    Hun_GameWriteLine( "GameState: " + GetGameState().tostring() )
    if( GetGameState() != eGameState.Playing && GetGameState() != -1 )
    {
        AddCallback_GameStateEnter( eGameState.Playing, OnGameStatePlaying )
    }
    AddCallback_GameStateEnter( eGameState.WinnerDetermined, OnGameStateWinnerDetermined )
}

float PlayingTime = 0.0

void function OnGameStatePlaying()
{
    Hun_Say( "[32m比赛开始" )
    PlayingTime = Time()
}

void function OnGameStateWinnerDetermined()
{
    Hun_Say( "[32m比赛结束" )
    if( PlayingTime == 0.0 )
        return
    float GameDuration = Time() - PlayingTime
    
    int minutes = int(GameDuration / 60)
    int seconds = int(GameDuration % 60)
    
    string secondsStr = seconds < 10 ? "0" + seconds : "" + seconds
    
    string durationText = "比赛用时: " + minutes + "分" + secondsStr + "秒"
    
    Hun_Say( "[32m" + durationText )
}

void function FD_BoughtItem( entity ent, var info )
{
    if( !IsValid(ent) || !IsAlive(ent) || !ent.IsPlayer() || ent == GetLocalClientPlayer() )
        return

    float distance = Distance2D( GetBoostStore().GetOrigin(), ent.GetOrigin() ) * 0.01904 / 0.75

    BurnReward burnReward = BurnReward_GetById( expect int( info ) )
    string localizedName = Localize( burnReward.localizedName )

    string name = ent.GetPlayerName()
    
    if( distance > 4.0 )
    {
        if( !BoostStore.contains(name) )
        {
            BoostStore.append(name)
            Hun_Say( "[31m" + name + " 檢測到遠程商店" )
        }
        string msg = name + " 远程购买 " + localizedName
        Hun_GameWriteLine( msg )
    }
    else
    {
        string msg = name + " 购买 " + localizedName
        Hun_GameWriteLine( msg )
    }
}

void function BoostStoreOpenCallback(entity boostStore)
{
    Hun_GameWriteLine( "商店开启" )
    GameWriteLineAllPlayerMoney()
    thread PingBoostStore( boostStore )
}

bool bzd = false
void function BoostStoreClosedCallback(entity boostStore)
{
    if(!bzd)bzd = true;return
    Hun_GameWriteLine( "商店关闭" )
    GameWriteLineAllPlayerMoney()
}

void function GameWriteLineAllPlayerMoney()
{
    foreach(player in GetPlayerArray())
    {
        if( !IsValid(player) )
            continue
        if( player == GetLocalClientPlayer() )
            continue
        
        int money = GetPlayerMoney( player )
        if( money <= 0 )
            continue

        Hun_GameWriteLine( player.GetPlayerName() + " 金额 " + money )
    }
}