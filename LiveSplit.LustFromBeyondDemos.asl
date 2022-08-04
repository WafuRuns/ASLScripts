state("Lust From Beyond - Prologue") {}

state("Lust From Beyond - Scarlet") {}

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
    IntPtr instancePtr = (IntPtr) BitConverter.ToInt64(game.ReadBytes(ptr, 8), 0);
    vars.watchers = new MemoryWatcherList();
    if (modules.First().ModuleName == "Lust From Beyond - Scarlet.exe") {
        vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer(instancePtr, 0x20, 0x52)) { Name = "gameIsStoppedByLoading" });
        vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x20, 0x40, 0x28, 0x30)) { Name = "hurtEvent", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
        vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer(instancePtr, 0x20, 0x40, 0x88, 0x46)) { Name = "canOpenPauseMenu", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
        vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x50, 0x18, 0x38)) { Name = "currentCheckpointID", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
        vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x50, 0x18, 0x20)) { Name = "sceneKey", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
    }
    else {
        vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer(instancePtr, 0x20, 0x4A)) { Name = "gameIsStoppedByLoading" });
        vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x20, 0x38, 0x18, 0x28, 0x30)) { Name = "hurtEvent", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
        vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x58, 0x18, 0x38)) { Name = "currentCheckpointID", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
        vars.watchers.Add(new MemoryWatcher<Int32>(new DeepPointer(instancePtr, 0x58, 0x18, 0x20)) { Name = "sceneKey", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
        vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer(instancePtr, 0x20, 0x38, 0x88, 0x46)) { Name = "canOpenPauseMenu", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
    }
}

update
{
    vars.watchers.UpdateAll(game);
}

isLoading
{
    return vars.watchers["hurtEvent"].Current == 0 || !vars.watchers["canOpenPauseMenu"].Current || vars.watchers["gameIsStoppedByLoading"].Current;
}

split
{
    return vars.watchers["sceneKey"].Current != 0 && vars.watchers["currentCheckpointID"].Current != vars.watchers["currentCheckpointID"].Old;
}
