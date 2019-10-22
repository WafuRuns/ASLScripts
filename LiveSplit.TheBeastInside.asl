state("TheBeastInside-Win64-Shipping")
{
	byte loading : 0x2BBE158, 0x80, 0x8, 0x2C8;
}

exit
{
    timer.IsGameTimePaused = true;
}

isLoading
{
        return current.loading == 1;
}
