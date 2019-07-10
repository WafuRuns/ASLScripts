state("arx")
{
    float progressBar : 0x45A86C;
}

exit
{
    timer.IsGameTimePaused = true;
}

isLoading
{
    return current.progressBar != 0;
}
