untyped
global function ClientChatCommand_Time_Init

void function ClientChatCommand_Time_Init()
{
    Hun_AddChatCommandCallback("@time", ClientChatCommand_Time)
}


void function ClientChatCommand_Time(entity player, array<string> args)
{
    table<string, array<string> > params
    NSHttpGet( "https://sapi.chinattas.com/time-serv", params, void function( HttpRequestResponse response ){
        try{
            table jsonData = DecodeJSON(response.body)
            string time = string(jsonData["sysTime2"])
            Hun_Say( time )
        }catch(error){
            Hun_Error( string(error) )
        }
    } )
}