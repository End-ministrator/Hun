global function ClientChatCommand_Orig_Init

void function ClientChatCommand_Orig_Init()
{
    Hun_AddChatCommandCallback("@orig", ClientChatCommand_Orig)
}

void function ClientChatCommand_Orig(entity player, array<string> args)
{
    array<entity> players = []
    
    if( args.len() == 0 || args[0].tolower() == "all")
        players = GetPlayerArray()
    else if(args.len() == 1)
        players = GetPlayersByNamePrefix(args[0])
    else
        return
    
    array<string> messages = []
    foreach(player in players)
    {
        messages.append( "[" + player.GetPlayerName() + "]" + "[坐标：" + player.GetOrigin().tostring() + "]" )
    }
    Hun_Says(messages)
}