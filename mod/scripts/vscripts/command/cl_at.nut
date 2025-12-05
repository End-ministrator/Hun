global function ChatCommand_At_Init

void function ChatCommand_At_Init()
{
    Hun_AddChatCommandCallback("@", OnChatCommand)
    Hun_AddChatCommandCallback("@hun", OnChatCommand)
}

void function OnChatCommand(entity player, array<string> args)
{  
    Hun_Say("GitHub: github.com/End-ministrator/Hun")
}