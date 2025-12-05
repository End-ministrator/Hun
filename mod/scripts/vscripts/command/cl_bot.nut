global function ChatCommand_Bot_Init

void function ChatCommand_Bot_Init()
{
    Hun_AddChatCommandCallback("@bot", OnChatCommand)
}

void function OnChatCommand(entity player, array<string> args)
{
    if(args.len() != 0){
        Hun_Say( "@bot" )
        return
    }
    
    array<string> messages = []
    foreach(player in GetBotArray())
    {
        messages.append( "[" + player.GetPlayerName() + "]" )
    }
    Hun_Says(messages)
}