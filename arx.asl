state("arx", "1.1.2")
{
    float progressBar : 0x45A86C;
}

state("arx", "1.0")
{
    float progressBar : 0x47DE0C;
}

init
{
    if (modules.First().ModuleMemorySize == 8790016)
        version = "1.1.2";
    if (modules.First().ModuleMemorySize == 9023488)
        version = "1.0";
}

exit
{
    timer.IsGameTimePaused = true;
}

isLoading
{
    return current.progressBar != 0;
}
