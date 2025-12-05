global function HunMessage_Init
global function Hun_GameWriteLine
global function Hun_IsPlayerBlocked

struct PlayerMessageData
{
    array<float> messageTimes = []
    float lastSpamWarning = 0.0
    bool hasWarned = false
}

table<string, PlayerMessageData> playerMessageHistory

void function HunMessage_Init()
{
    AddCallback_OnReceivedSayTextMessage(OnReceivedSayTextMessage_SpamDetection)
}

ClClient_MessageStruct function OnReceivedSayTextMessage_SpamDetection(ClClient_MessageStruct message)
{
    entity player = message.player

    if( player == GetLocalClientPlayer() )
        return message

    string playerName = player.GetPlayerName()
    float currentTime = Time()
    
    if(!(playerName in playerMessageHistory))
    {
        PlayerMessageData data
        playerMessageHistory[playerName] <- data
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
        message.shouldBlock = true
        if(!playerData.hasWarned || currentTime - playerData.lastSpamWarning > 30.0)
        {
            playerData.hasWarned = true
            playerData.lastSpamWarning = currentTime
            
            string warningMsg = "检测到玩家 " + playerName + " 刷屏，已屏蔽消息"
            Hun_Say(warningMsg)
        }
    }
    
    return message
}

void function Hun_GameWriteLine(string text)
{
    Chat_GameWriteLine( "[36m[魂][33m" + text )
}

bool function Hun_IsPlayerBlocked(string playerName)
{
    if(!(playerName in playerMessageHistory))
        return false
    
    PlayerMessageData playerData = playerMessageHistory[playerName]
    float currentTime = Time()
    
    for(int i = playerData.messageTimes.len() - 1; i >= 0; i--)
    {
        if(currentTime - playerData.messageTimes[i] > 10.0)
            playerData.messageTimes.remove(i)
    }
    
    return playerData.messageTimes.len() >= 4
}