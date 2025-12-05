global function ClientChatCommand_Dist_Init

void function ClientChatCommand_Dist_Init()
{
    Hun_AddChatCommandCallback("@dist", ClientChatCommand_Dist)
}

void function ClientChatCommand_Dist(entity player, array<string> args)
{
    if(args.len() != 2){
        Hun_Say( "@dist <name> <name>" )
        return
    }
    entity target = GetPlayerByNamePrefix(args[0])
    entity target2 = GetPlayerByNamePrefix(args[1])
    if( !IsValid(target) || !IsValid(target2))
        return
    float distance = Distance2D( target.GetOrigin(), target2.GetOrigin() ) * 0.01904 / 0.75
    Hun_Say( "距离：" + distance.tostring() )
}