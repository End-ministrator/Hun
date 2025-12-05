global function ChatCommandCallback_Init
global function Hun_AddChatCommandCallback
global function Hun_SetChatCommandCallback
global function Hun_IsChatCommandRegistered
global function Hun_RemoveChatCommandCallback

table< string, void functionref(entity player, array<string> args) > ChatCommandCallbacks = {}

void function ChatCommandCallback_Init()
{
    AddCallback_OnReceivedSayTextMessage( OnReceivedSayTextMessage )
}

ClClient_MessageStruct function OnReceivedSayTextMessage(ClClient_MessageStruct message)
{
    entity player = message.player
    string playerName = player.GetPlayerName()
    string chatText = message.message

    array<string> words = split(chatText, " ")
    string command = words[0]
    array<string> args = []
    for(int i = 1; i < words.len(); i++) {
        if (words[i] != "")
            args.append(words[i])
    }
    
    if(command in ChatCommandCallbacks)
    {
        //if( playerName == "Pathstar_XD" ){
        //    if( !Hun_IsPlayerBlocked(playerName) )
        //        Hun_Say( "你已被添加到黑名单" )
        //    return message
        //}
        array<string> args = words.slice(1)
        thread ChatCommandCallbacks[command]( player, args )
    }

    return message
}

bool function Hun_AddChatCommandCallback(string command, void functionref(entity player, array<string> args) func)
{
    if( command == "" || func == null )
        return false
    if(command in ChatCommandCallbacks)
        return false
    ChatCommandCallbacks[command] <- func
    return true
}

bool function Hun_SetChatCommandCallback(string command, void functionref(entity player, array<string> args) func)
{
    if( command == "" || !(command in ChatCommandCallbacks) )
        return false
    ChatCommandCallbacks[command] = func
    return true
}

bool function Hun_IsChatCommandRegistered(string command)
{
    if( command == "" )
        return false
    return (command in ChatCommandCallbacks)
}

bool function Hun_RemoveChatCommandCallback(string command)
{
    if( command == "" || !(command in ChatCommandCallbacks) )
        return false
    delete ChatCommandCallbacks[command]
    return true
}