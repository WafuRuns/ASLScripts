state("LustForDarkness") {}

startup
{
    // LoadingScreenManager
    vars.scanTarget = new SigScanTarget(81, "558BEC575683EC208B7D0883EC0C6A00E8????????83C4108D45E883EC0C50E8????????83C40C6A0083EC088B45E88904248B45EC894424046A00E8????????83C41083EC0C6A01E8????????83C410B8????????89388B05????????83EC086A0050E8????????83C41085C07412");
    // GameManager
    vars.scanTarget2 = new SigScanTarget(11, "558BEC5783EC048B7D08B8????????89388B475483EC0C50");
    // FirstPersonController
    vars.scanTarget3 = new SigScanTarget(59, "558BEC5781EC????????8B7D08C785????????00000000C7458000000000C7458400000000C7458800000000C7458C00000000C7459000000000B8????????893883EC0C57E8????????83C410894714BA????????83EC0C57E8????????83C41083EC0C503900E8????????83C4108947188D4D9483EC0850513900E8????????83C40C8D87C00000008B4D9489088B4D988948048B4D9C8948088B4DA089480C8D87????????8985????????8D45A483EC0C50E8????????83C40C8B47188D8D????????83EC0850513900");
    // Creating custom scan function that accepts:
    // SigScanTarget (calls it target) and Process (calls it g)
    // Returns:
    // IntPtr
    vars.scan = new Func<SigScanTarget, Process, IntPtr>((target, g) => {
        IntPtr ptr = IntPtr.Zero;
        // Finds pointer in all pages
        foreach (var page in g.MemoryPages()) {
            // Prepares scanner
            var scanner = new SignatureScanner(g, page.BaseAddress, (int)page.RegionSize);
            // If pointer, is still not found, scan for signature
            if (ptr == IntPtr.Zero) {
                ptr = scanner.Scan(target);
            }
            // If pointer is found, exit the loop
            if (ptr != IntPtr.Zero) {
                // Read 4 bytes and convert them to 32 bit address and return it
                return (IntPtr) BitConverter.ToInt32(game.ReadBytes(ptr, 4), 0);
            }
        }
        // Return null pointer if pointer wasn't found
        return ptr;
    });
}

init
{
    // Create watcher list
    vars.watchers = new MemoryWatcherList();
    // Use function for all scan targets
    IntPtr instancePtr = vars.scan(vars.scanTarget, game);
    IntPtr instancePtr2 = vars.scan(vars.scanTarget2, game);
    IntPtr instancePtr3 = vars.scan(vars.scanTarget3, game);
    // Create memory watcher, read the new pointer + offsets and name it
    vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer(instancePtr, 0xC, 0xB9)) { Name = "FinishLoad" });
    vars.watchers.Add(new StringWatcher(new DeepPointer(instancePtr2, 0x38), 10) { Name = "loadLevelName" });
    vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer(instancePtr3, 0xD0)) { Name = "runningLocker" });
}

update
{
    // Update all watchers every 60 frames
    vars.watchers.UpdateAll(game);
    // You can set the refresh rate to higher number:
    // refreshRate = 120; // This would go to init or startup block
}

split
{
    // If loadLevelName changes, split
    return vars.watchers["loadLevelName"].Changed;
}

isLoading
{
    // If FinishLoad is false, remove loads
    // OR
    // If runningLocker is false, remove loads
    return !vars.watchers["FinishLoad"].Current || !vars.watchers["runningLocker"].Current;
}
