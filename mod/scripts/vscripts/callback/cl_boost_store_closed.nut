global function BoostStoreClosedCallback_Init
global function AddBoostStoreClosedCallback
global function RemoveBoostStoreClosedCallback

array< void functionref(entity) > Callbacks = []

void function BoostStoreClosedCallback_Init()
{
    thread main()
}

void function main()
{
    WaitFrame()
    while(true)
    {
        if( !BoostStoreOpen() )
        {
            TriggerBoostStoreClosedCallbacks()
            waitthread WaitUntilBoostStoreOpen()
        }
        WaitFrame()
    }
}

void function TriggerBoostStoreClosedCallbacks()
{
    foreach( func in Callbacks )
    {
        thread func(GetBoostStore())
    }
}

void function AddBoostStoreClosedCallback( void functionref(entity) func )
{
    if( func == null )
        return
    if( !Callbacks.contains(func) )
    {
        Callbacks.append(func)
    }
}

void function RemoveBoostStoreClosedCallback( void functionref(entity) func )
{
    if( func == null )
        return
    if(Callbacks.contains(func))
    {
        Callbacks.remove(Callbacks.find(func))
    }
}