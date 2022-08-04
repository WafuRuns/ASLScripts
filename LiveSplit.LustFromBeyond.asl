state("Lust From Beyond M Edition") {}

init
{
    vars.scanTarget = new SigScanTarget(17, "55488BEC4883EC30488975F8488BF148B8????????????????488B08669049BB????????????????41FFD385C07429");
    IntPtr ptr = IntPtr.Zero;
    foreach (var page in game.MemoryPages()) {
        var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
        ptr = scanner.Scan(vars.scanTarget);		
        if (ptr != IntPtr.Zero) {
            break;
        }
    }
    if (ptr == IntPtr.Zero)
        print("Didn't work."); //make this exception
    IntPtr instancePtr = (IntPtr) BitConverter.ToInt64(game.ReadBytes(ptr, 8), 0);
    vars.watchers = new MemoryWatcherList();
    vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer(instancePtr, 0x20, 0x53)) { Name = "gameIsStoppedByLoading" });
    vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x50, 0x18, 0x48)) { Name = "currentCheckpointID", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
    vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x50, 0x18, 0x20)) { Name = "sceneKey", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
}

update
{
    vars.watchers.UpdateAll(game);
}

isLoading
{
    return vars.watchers["gameIsStoppedByLoading"].Current || vars.watchers["sceneKey"].Current == 0;
}

split
{
    return vars.watchers["sceneKey"].Current != 0 && vars.watchers["currentCheckpointID"].Current != vars.watchers["currentCheckpointID"].Old;
}
