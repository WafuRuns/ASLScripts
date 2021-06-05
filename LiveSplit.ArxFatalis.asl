state("arx", "1.1.2")
{
    float progressBar : 0x45A86C;
    byte cutscene : 0x45A634;
    string7 level : 0x3DCB60, 0xD;
}

state("arx", "1.0.3")
{
    float progressBar : 0x47ED3C;
    byte cutscene : 0x47EADC;
    string7 level : 0x3EB780, 0xD;
}

state("arx", "1.0")
{
    float progressBar : 0x47DE0C;
    byte cutscene : 0x47DBAC;
    string7 level : 0x3EA7F0, 0xD;
}

startup
{
    settings.Add("endsplit", false, "Split on killing Akbaa (experimental)");
    vars.levels = new List<string>() {
        "15", "1", "12", "14", "1", "2",
        "13", "11", "13", "2", "3", "16",
        "18", "5", "6", "7", "2", "1",
        "14", "1", "2", "3", "4"
    };
    vars.crash = false;
}

update
{
    if (current.progressBar != 0)
        vars.crash = false;
}

start
{
    return current.cutscene == 0 && old.cutscene == 1;
}

init
{
    if (modules.First().ModuleMemorySize == 8790016)
        version = "1.1.2";
    if (modules.First().ModuleMemorySize == 8925184)
        version = "1.0.3";
    if (modules.First().ModuleMemorySize == 9023488)
        version = "1.0";
    vars.levelNum = timer.CurrentSplitIndex;
    if (vars.levelNum < 0)
        vars.levelNum = 0;
}

split
{
    if (settings["endsplit"]) {
        if (current.level == "level4")
            return current.cutscene == 1 && old.cutscene == 0;
    }
    if ("level" + vars.levels[vars.levelNum] == current.level) {
        vars.levelNum++;
        return true;
    }
}

exit
{
    vars.crash = true;
    timer.IsGameTimePaused = true;
}

isLoading
{
    return current.progressBar != 0 || vars.crash;
}
