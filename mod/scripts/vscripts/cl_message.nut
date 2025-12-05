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
    AddCallback_OnReceivedSayTextMessage(OnReceivedSayTextMessage)
}

ClClient_MessageStruct function OnReceivedSayTextMessage(ClClient_MessageStruct message)
{
    entity player = message.player
    string playerName = player.GetPlayerName()
    
    if( player == GetLocalClientPlayer() )
        return message
    
    if(Hun_IsPlayerBlocked(playerName))
    {
        float currentTime = Time()
        
        if(!(playerName in playerMessageHistory))
        {
            playerMessageHistory[playerName] <- PlayerMessageData()
        }
        
        PlayerMessageData playerData = playerMessageHistory[playerName]
        
        if(currentTime - playerData.lastSpamWarning > 30.0)
        {
            playerData.lastSpamWarning = currentTime
            
            string warningMsg = "检测到玩家 " + playerName + " 刷屏，已屏蔽消息"
            Hun_Say(warningMsg)
        }
        
        message.shouldBlock = true
    }
    
    return message
}

void function Hun_GameWriteLine(string text)
{
    Chat_GameWriteLine("[36m[魂][33m" + text)
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
    
    playerData.messageTimes.append(currentTime)

    return playerData.messageTimes.len() >= 4
}