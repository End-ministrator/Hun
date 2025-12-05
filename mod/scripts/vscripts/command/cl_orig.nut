global function ClientChatCommand_Orig_Init

void function ClientChatCommand_Orig_Init()
{
    Hun_AddChatCommandCallback("@orig", ClientChatCommand_Orig)
}

void function ClientChatCommand_Orig(entity player, array<string> args)
{
    if( args.len() != 1 ){
        Hun_Say( "Usage: @orig [all|name]" )
        return
    }
    
    array<entity> players = []
    switch( args[0].tolower() ){
        case "all":
            players = GetPlayerArray()
            break
        default:
            players = GetPlayersByNamePrefix(args[0])
            break
    }
    
    array<string> messages = []
    foreach(player in players)
    {
        messages.append( "[" + player.GetPlayerName() + "]" + "[坐标：" + player.GetOrigin().tostring() + "]" )
    }
    Hun_Says(messages)
}