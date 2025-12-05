global function ClientChatCommand_Gen_Init

void function ClientChatCommand_Gen_Init()
{
    Hun_AddChatCommandCallback("@gen", ClientChatCommand_Gen)
}

void function ClientChatCommand_Gen(entity player, array<string> args)
{
    if(args.len() != 1){
        Hun_Say( "Usage: @gen [name/all]" )
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
        messages.append( "[" + player.GetPlayerName() + "]" + "[" + PlayerXPDisplayGenAndLevel(player.GetGen(), player.GetLevel()) + "]" )
    }
    Hun_Says(messages)
}