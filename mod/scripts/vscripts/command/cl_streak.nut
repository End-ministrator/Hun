global function ClientChatCommand_Streak_Init
global function Hun_OnKilled
global function Hun_GetPlayerStreak
global function Hun_ClearAllStreaks

struct PlayerStreakData
{
    int streakCount = 0
    float lastKillTime = 0.0
    int lifeKills = 0
    bool isAlive = true
}

table<entity, PlayerStreakData> playerStreaks

bool StreakEnabled = false
int StreakMode = 1

void function ClientChatCommand_Streak_Init()
{
    Hun_AddChatCommandCallback( "@streak", ClientChatCommand_Streak )
    thread CheckPlayersStatusThread()
}

void function ClientChatCommand_Streak(entity player, array<string> args)
{
    if( args.len() == 0 || player != GetLocalClientPlayer() )
        return
    
    if(args.len() == 1)
    {
        if(args[0] == "on")
        {
            StreakEnabled = true
            Hun_Say("连杀系统已启用 - 模式-" + StreakMode)
        }
        else if(args[0] == "off")
        {
            StreakEnabled = false
            Hun_ClearAllStreaks()
            Hun_Say("连杀系统已关闭")
        }
        else if(args[0] == "status")
        {
            string status = StreakEnabled ? "启用" : "关闭"
            Hun_Say("连杀系统: " + status + " - 模式-" + StreakMode)
        }
    }
    else if(args.len() == 2)
    {
        if(args[0] == "mode")
        {
            if(args[1] == "1")
            {
                StreakMode = 1
                Hun_ClearAllStreaks()
                Hun_Say("已切换到模式-1: 10秒内连续击杀")
            }
            else if(args[1] == "2")
            {
                StreakMode = 2
                Hun_ClearAllStreaks()
                Hun_Say("已切换到模式-2: 单条生命击杀数")
            }
        }
    }
}

void function Hun_OnKilled( entity attacker, entity victim )
{
    if( !StreakEnabled )
        return
    if( !IsValid( attacker ) || !IsValid( victim ) )
        return
    if( !attacker.IsPlayer() || !victim.IsPlayer() )
        return
    if( attacker == victim )
        return
    
    print( attacker.GetPlayerName() + " Ko " + victim.GetPlayerName() )
    
    if( !(attacker in playerStreaks) )
    {
        PlayerStreakData data
        data.isAlive = true
        playerStreaks[attacker] <- data
    }
    
    PlayerStreakData attackerData = playerStreaks[attacker]
    
    if( StreakMode == 1 ) // 模式1: 10秒内连续击杀
    {
        float currentTime = Time()
        if( currentTime - attackerData.lastKillTime <= 10.0 ){
            attackerData.streakCount++
        }
        else{
            attackerData.streakCount = 1
        }
        
        attackerData.lastKillTime = currentTime
        
        // 显示连杀信息（从3连杀开始显示）
        if( attackerData.streakCount >= 3 )
        {
            string streakMsg = GetStreakMessage(attackerData.streakCount)
            Hun_Say( attacker.GetPlayerName() + " " + streakMsg )
        }
    }
    else if( StreakMode == 2 ) // 模式2: 单条生命击杀数
    {
        attackerData.lifeKills++
        attackerData.streakCount = attackerData.lifeKills
        
        if( attackerData.lifeKills >= 3 )
        {
            string streakMsg = GetStreakMessage(attackerData.lifeKills)
            Hun_Say( attacker.GetPlayerName() + " " + streakMsg )
        }
    }
    
    // 处理受害者连杀终结
    if( victim in playerStreaks )
    {
        PlayerStreakData victimData = playerStreaks[victim]
        
        // 标记受害者死亡（用于模式2）
        victimData.isAlive = false
        
        if( StreakMode == 1 )
        {
            if( victimData.streakCount >= 3 )
            {
                string deathMessage = "的" + victimData.streakCount + "连杀被" + attacker.GetPlayerName() + "终结了!"
                Hun_Say( victim.GetPlayerName() + deathMessage )
            }
        }
        else if( StreakMode == 2 )
        {
            if( victimData.lifeKills >= 3 )
            {
                string deathMessage = "的" + victimData.lifeKills + "连杀被" + attacker.GetPlayerName() + "终结了!"
                Hun_Say( victim.GetPlayerName() + deathMessage )
            }
        }
    }
}

// 线程：定期检查玩家状态
void function CheckPlayersStatusThread()
{
    WaitFrame()
    while( true )
    {
        WaitFrame()
        
        if( !StreakEnabled )
            continue
            
        array<entity> players = GetPlayerArray()
        foreach( player in players )
        {
            if( !IsValid(player) )
                continue
                
            if( player in playerStreaks )
            {
                PlayerStreakData data = playerStreaks[player]
                bool currentAliveState = IsAlive(player)
                
                // 如果玩家从死亡状态变为存活状态（重生）
                if( !data.isAlive && currentAliveState )
                {
                    // 模式2：重置生命击杀数
                    if( StreakMode == 2 )
                    {
                        data.lifeKills = 0
                        data.streakCount = 0
                    }
                    data.isAlive = true
                }
                // 如果玩家从存活状态变为死亡状态
                else if( data.isAlive && !currentAliveState )
                {
                    data.isAlive = false
                }
            }
            else if( IsAlive(player) )
            {
                // 如果玩家存活但没有数据，初始化数据
                PlayerStreakData newData
                newData.isAlive = true
                playerStreaks[player] <- newData
            }
        }
        CleanupInvalidPlayers()
    }
}

// 清理无效玩家的数据
void function CleanupInvalidPlayers()
{
    array<entity> playersToRemove = []
    
    foreach( player, data in playerStreaks )
    {
        if( !IsValid(player) || !player.IsPlayer() )
        {
            playersToRemove.append(player)
        }
    }
    
    foreach( player in playersToRemove )
    {
        delete playerStreaks[player]
    }
}

string function GetStreakMessage( int streakCount )
{
    switch( streakCount )
    {
        case 2:
            return streakCount + " 连杀!"
        case 3:
            return streakCount + " 连杀! 杀戮开始!"
        case 4:
            return streakCount + " 连杀! 势不可挡!"
        case 5:
            return streakCount + " 连杀! 主宰比赛!"
        case 6:
            return streakCount + " 连杀! 无人能挡!"
        case 7:
            return streakCount + " 连杀! 如同神一般!"
        case 8:
            return streakCount + " 连杀! 超越神了!"
        default:
            if( streakCount > 8 )
                return streakCount + " 连杀! 超越神了!"
            else
                return streakCount + " 连杀!"
    }
    unreachable
}

int function Hun_GetPlayerStreak( entity player )
{
    if( player in playerStreaks )
    {
        if( StreakMode == 1 )
        {
            if( Time() - playerStreaks[player].lastKillTime <= 10.0 )
                return playerStreaks[player].streakCount
            else
                return 0
        }
        else if( StreakMode == 2 )
        {
            return playerStreaks[player].lifeKills
        }
    }
    return 0
}

void function Hun_ClearAllStreaks()
{
    playerStreaks.clear()
}