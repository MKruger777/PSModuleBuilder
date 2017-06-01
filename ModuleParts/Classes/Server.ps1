
enum OSType
{
    Unknown
    Windows
    Linux
}

enum OSState
{
    Unknown
    ShutingDown
    StartingUp
	Sleeping
	Suspended
}

class Server
{
    [string] $Name;
    [OSType] $OSType;
	[OSState] $OSState;
	
    Server() {}
	
    [String] Start()
    {
        return  "Server " + $this.Name + " is Starting...";
		$this.OSState = OSState.ShuttingDown;
    }	
	
    [String] Stop()
    {
        return  "Server " + $this.Name + " is Stoping..."
        $this.OSState = OSState.Shutting;
    }		
}