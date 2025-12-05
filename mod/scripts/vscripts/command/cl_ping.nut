global function ClientChatCommand_Ping_Init

struct PingData
{
    entity player
    int ping
}

void function ClientChatCommand_Ping_Init()
{
    Hun_AddChatCommandCallback("@ping", ClientChatCommand_Ping)
}

void function ClientChatCommand_Ping(entity player, array<string> args)
{
    if( args.len() != 1 ){
        Hun_Say( "Usage: @ping [all|name]" )
        return
    }

    array<entity> players = []
    switch( args[0].tolower() )
    {
        case "all":
            players = GetPlayerArray()
            break
        default:
            players = GetPlayersByNamePrefix(args[0])
            break
    }
    
    array<PingData> pings
    foreach(player in players)
    {
        PingData ping
        ping.player = player
        ping.ping = GetPlayerPing(player)
        pings.append( ping )
    }
    pings.sort(PingSort)
    array<string> messages
    foreach(ping in pings)
    {
        messages.append( "[" + ping.player.GetPlayerName() + "]" + "[" + ping.ping + "ms]" )
    }
    Hun_Says(messages)
}

int function PingSort(PingData a, PingData b)
{
    if (a.ping < b.ping)
        return 1
    else if (a.ping > b.ping)
        return -1
    
    return 0
}