state("arx", "1.1.2")
{
    float progressBar : 0x45A86C;
}

state("arx", "1.0.3")
{
    float progressBar : 0x47ED3C;
}

state("arx", "1.0")
{
    float progressBar : 0x47DE0C;
}

update
{
    if (current.progressBar != 0)
        vars.crash = false;
}

init
{
    if (modules.First().ModuleMemorySize == 8790016)
        version = "1.1.2";
    if (modules.First().ModuleMemorySize == 8925184)
        version = "1.0.3";
    if (modules.First().ModuleMemorySize == 9023488)
        version = "1.0";
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
