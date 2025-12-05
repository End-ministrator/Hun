global function BoostStoreOpenCallback_Init
global function AddBoostStoreOpenCallback
global function RemoveBoostStoreOpenCallback

array< void functionref(entity) > Callbacks = []

void function BoostStoreOpenCallback_Init()
{
    thread main()
}

void function main()
{
    WaitFrame()
    while(true)
    {
        if(BoostStoreOpen())
        {
            TriggerBoostStoreOpenCallbacks()
            waitthread WaitUntilBoostStoreClose()
        }
        WaitFrame()
    }
}

void function TriggerBoostStoreOpenCallbacks()
{
    foreach( func in Callbacks )
    {
        thread func(GetBoostStore())
    }
}

void function AddBoostStoreOpenCallback( void functionref(entity) func )
{
    if( func == null )
        return
    if( !Callbacks.contains(func) )
    {
        Callbacks.append(func)
    }
}

void function RemoveBoostStoreOpenCallback( void functionref(entity) func )
{
    if( func == null )
        return
    if( Callbacks.contains(func) )
    {
        Callbacks.remove(Callbacks.find(func))
    }
}