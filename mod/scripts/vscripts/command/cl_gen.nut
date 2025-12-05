global function ClientChatCommand_Gen_Init

void function ClientChatCommand_Gen_Init()
{
    Hun_AddChatCommandCallback("@gen", ClientChatCommand_Gen)
}

void function ClientChatCommand_Gen(entity player, array<string> args)
{
    if(args.len() != 1){
        Hun_Say( "@gen <name/all>" )
        return
    }

    string arg0Lower = args[0].tolower()
    array<entity> players = []
    
    if( arg0Lower == "all")
        players = GetPlayerArray()
    else
        players = GetPlayersByNamePrefix(arg0Lower)
    
    array<string> messages = []
    foreach(player in players)
    {
        messages.append( "[" + player.GetPlayerName() + "]" + "[" + PlayerXPDisplayGenAndLevel(player.GetGen(), player.GetLevel()) + "]" )
    }
    Hun_Says(messages)
}