untyped
global function HunMessage_Init
global function Hun_GameWriteLine
global function Hun_IsPlayerBlocked

struct PlayerMessageData
{
    array<float> messageTimes = []
    float lastSpamWarning = 0.0
}

table<string, PlayerMessageData> playerMessageHistory

void function HunMessage_Init()
{
    AddCallback_OnReceivedSayTextMessage(OnReceivedSayTextMessage_SpamDetection)
}

ClClient_MessageStruct function OnReceivedSayTextMessage_SpamDetection(ClClient_MessageStruct message)
{
    print( message.player.GetPlayerName() + "  " + message.message )
    if( !IsValid(message.player) || message.player == GetLocalClientPlayer() )
        return message

    string playerName = message.player.GetPlayerName()
    float currentTime = Time()
    
    if(!(playerName in playerMessageHistory))
    {
        PlayerMessageData playerData
        playerData.messageTimes = []
        playerData.lastSpamWarning = -9999.0

        playerMessageHistory[playerName] <- playerData
    }
    
    PlayerMessageData playerData = playerMessageHistory[playerName]
    
    for(int i = playerData.messageTimes.len() - 1; i >= 0; i--)
    {
        if(currentTime - playerData.messageTimes[i] > 10.0)
            playerData.messageTimes.remove(i)
    }
    
    playerData.messageTimes.append(currentTime)
    
    if(playerData.messageTimes.len() >= 4)
    {
        //message.shouldBlock = true
        
        if(currentTime - playerData.lastSpamWarning > 30.0)
        {
            playerData.lastSpamWarning = currentTime
            
            string warningMsg = "检测到玩家 " + playerName + " 刷屏，已屏蔽消息"
            print(warningMsg)
            Hun_Say(warningMsg)
        }
    }
    
    return message
}

void function Hun_GameWriteLine(string text)
{
    Chat_GameWriteLine( "[36m[魂][33m" + text )
}

/**
 * 判断玩家是否被屏蔽
 * @param playerName 玩家名称
 * @return bool 如果玩家在最近10秒内发送了6条或更多消息，返回true，否则返回false
 */
bool function Hun_IsPlayerBlocked(string playerName)
{
    if(!(playerName in playerMessageHistory))
        return false
    
    PlayerMessageData playerData = playerMessageHistory[playerName]
    float currentTime = Time()
    
    // 清理过期的消息记录
    for(int i = playerData.messageTimes.len() - 1; i >= 0; i--)
    {
        if(currentTime - playerData.messageTimes[i] > 10.0)
            playerData.messageTimes.remove(i)
    }
    
    // 检查消息数量是否达到屏蔽条件
    return playerData.messageTimes.len() >= 4
}