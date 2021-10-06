state("D2R") {}

startup
{
    vars.scanTarget = new SigScanTarget(17, "00A899??????7F00001000??????7F00000?");
}

init
{
    vars.exit = true;
}

update
{
    if (vars.exit) {
        vars.watchers = new MemoryWatcherList();
        IntPtr ptr = IntPtr.Zero;
        foreach (var page in game.MemoryPages().Reverse()) {
            var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
            ptr = scanner.Scan(vars.scanTarget);
            if (ptr != IntPtr.Zero) break;
        }
        vars.watchers.Add(new MemoryWatcher<bool>(ptr) { Name = "playing" });
        vars.exit = false;
    }
    vars.watchers.UpdateAll(game);
}

isLoading
{
    return !vars.watchers["playing"].Current;
}

exit
{
    vars.exit = false;
}
