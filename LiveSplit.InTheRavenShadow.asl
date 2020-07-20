state("havran")
{
    byte cutscene : 0xE2714;
    byte location : 0xE1F20;
    byte menu : 0x2948EE;
}

start
{
    if (current.cutscene == 1 && old.cutscene == 0 && current.menu != 240)
        return true;
}

split
{
    if (old.location == 121 && current.location == 60)
        return true;
    if (old.location == 90 && current.location == 119)
        return true;
    if (old.location == 45 && current.location == 87)
        return true;
    if (old.location == 87 && current.location == 67)
        return true;
    if (old.location == 217 && current.location == 50)
        return true;
    if (old.location == 44 && current.location == 57)
        return true;
    if (old.location == 70 && current.location == 33)
        return true;
    if (current.location == 160 && old.cutscene == 0 && current.cutscene == 1)
        return true;
}
