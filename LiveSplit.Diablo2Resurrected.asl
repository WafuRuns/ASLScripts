state("D2R") {}

startup
{
    vars.scanTarget = new SigScanTarget(17, "00A899??????7F00001000??????7F00000???????????????????????????????A0");
    vars.scanTarget2 = new SigScanTarget(19, "7F0000??????????7F000000000000000000000?00000000000000??????????7F0000CA");
    vars.scan = new Func<SigScanTarget, Process, bool, IntPtr>((target, g, rev) => {
        IntPtr ptr = IntPtr.Zero;
        if (rev) {
            foreach (var page in g.MemoryPages().Reverse()) {
                var scanner = new SignatureScanner(g, page.BaseAddress, (int)page.RegionSize);
                ptr = scanner.Scan(target);
                if (ptr != IntPtr.Zero) break;
            }
        }
        else {
            foreach (var page in g.MemoryPages()) {
                var scanner = new SignatureScanner(g, page.BaseAddress, (int)page.RegionSize);
                ptr = scanner.Scan(target);
                if (ptr != IntPtr.Zero) break;
            }
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
        IntPtr ptr = vars.scan(vars.scanTarget, game, true);
        IntPtr ptr2 = vars.scan(vars.scanTarget2, game, false);
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
