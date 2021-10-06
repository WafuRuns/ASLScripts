state("D2R") {}

startup
{
    vars.scanTarget = new SigScanTarget(17, "00A899??????7F00001000??????7F00000?");
    vars.scanTarget2 = new SigScanTarget(19, "7F0000??????????7F000000000000000000000?0000000000000020ED??????7F0000CA");
    vars.scan = new Func<SigScanTarget, Process, IntPtr>((target, g) => {
        IntPtr ptr = IntPtr.Zero;
        foreach (var page in g.MemoryPages().Reverse()) {
		    var scanner = new SignatureScanner(g, page.BaseAddress, (int)page.RegionSize);
            ptr = scanner.Scan(target);
            if (ptr != IntPtr.Zero) break;
        }
        return ptr;
    });
}

init
{
    vars.exit = true;
}

update
{
    if (vars.exit) {
        vars.watchers = new MemoryWatcherList();
        IntPtr ptr = vars.scan(vars.scanTarget, game);
        IntPtr ptr2 = vars.scan(vars.scanTarget2, game);
        if (ptr != IntPtr.Zero && ptr2 != IntPtr.Zero) {
            vars.watchers.Add(new MemoryWatcher<bool>(ptr) { Name = "playing" });
            vars.watchers.Add(new MemoryWatcher<bool>(ptr2) { Name = "cutscene" });
            vars.exit = false;
        }
    }
    vars.watchers.UpdateAll(game);
}

isLoading
{
    return !vars.watchers["playing"].Current && !vars.watchers["cutscene"].Current;
}

exit
{
    vars.exit = false;
}
