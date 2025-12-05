global function HunSay_Init
global function Hun_Say
global function Hun_Error
global function Hun_Says
global function Hun_ClearQueue
global function Hun_GetQueueSize

struct MessageQueue
{
    array<string> messages = []
}

MessageQueue file

const float MESSAGE_DELAY = 1.0
const int MAX_MESSAGES_PER_FRAME = 1
const string MESSAGE_PREFIX = "[36m[魂][33m"

void function HunSay_Init()
{
    thread HunSay()
}

void function HunSay()
{
    WaitFrame()
    
    while (true)
    {
        if(file.messages.len() > 0){
            float messagesToProcess = min(MAX_MESSAGES_PER_FRAME, file.messages.len())
            
            for(int i = 0; i < messagesToProcess; i++){
                if(file.messages.len() > 0)
                {
                    string message = file.messages.remove(0)
                    SendFormattedMessage(message)
                }
            }
            
            if(file.messages.len() > 0)
            {
                wait MESSAGE_DELAY
            }else{
                WaitFrame()
            }
        }else{
            WaitFrame()
        }
    }
}

void function Hun_ClearQueue()
{
    file.messages.clear()
}

void function Hun_Say(string message)
{
    if(message != "")
    {
        file.messages.append(message)
    }
}

void function Hun_Error(string message)
{
    if(message != "")
    {
        file.messages.append( "[ERROR]" + message)
    }
}

void function Hun_Says(array<string> messages)
{
    foreach(message in messages)
    {
        if(message != "")
        {
            file.messages.append(message)
        }
    }
}

int function Hun_GetQueueSize()
{
    return file.messages.len()
}

void function SendFormattedMessage(string message)
{
    entity localPlayer = GetLocalClientPlayer()
    if(IsValid(localPlayer))
    {
        localPlayer.ClientCommand("say " + MESSAGE_PREFIX + message)
    }
}