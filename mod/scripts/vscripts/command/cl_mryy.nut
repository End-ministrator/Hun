global function ClientChatCommand_Mryy_Init

void function ClientChatCommand_Mryy_Init()
{
    Hun_AddChatCommandCallback("@mryy", ClientChatCommand_Mryy)
}

void function ClientChatCommand_Mryy(entity player, array<string> args)
{
    if( args.len() != 0 ){
        Hun_Say( "Usage: @mryy" )
        return
    }
    
    table<string, array<string> > params
    NSHttpGet( "https://api.nxvav.cn/api/yiyan/?encode=json&charset=utf-8", params, void function( HttpRequestResponse response ){
        try{
            table jsonData = DecodeJSON(response.body)
            string yiyan = string(jsonData["yiyan"])
            Hun_Say( "每日一言：" + yiyan )
        }catch(error){
            Hun_Error( string(error) )
        }
    } )
}