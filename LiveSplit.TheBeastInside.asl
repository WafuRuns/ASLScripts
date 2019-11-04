state("TheBeastInside-Win64-Shipping")
{
	byte loading : 0x286EB80, 0x1E8, 0xF0, 0x0, 0x8, 0x2C8;
}

exit
{
    timer.IsGameTimePaused = true;
}

isLoading
{
        return current.loading == 1;
}
