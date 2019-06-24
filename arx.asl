state("arx")
{
    int menu : 0x3EEB50;
    float progressBar : 0x45A86C;
}

start
{
     return ((current.menu == 0) && (old.menu == 3));
}

exit
{
    timer.IsGameTimePaused = true;
}

isLoading
{
    return current.progressBar != 0;
}
