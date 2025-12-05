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
    array<entity> players = []
    if( args.len() == 0 || args[0].tolower() == "all")
        players = GetPlayerArray()
    else if(args.len() == 1)
        players = GetPlayersByNamePrefix(args[0])
    else
        return
    
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