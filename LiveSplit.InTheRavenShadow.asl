state("havran")
{
    byte cutscene : 0xE2714;
    byte location : 0xE1F20;
    byte menu : 0x2948EE;
}

start
{
    if (current.cutscene == 1 && old.cutscene == 0 && current.menu != 240)
    {
        vars.chapter = 0;
        return true;
    }
}

split
{
    switch ((int)vars.chapter)
    {
        case 0:
            if (current.location == 60) {
                vars.chapter++;
                return true;
            }
            break;
        case 1:
            if (current.location == 119) {
                vars.chapter++;
                return true;
            }
            break;
        case 2:
            if (current.location == 87) {
                vars.chapter++;
                return true;
            }
            break;
        case 3:
            if (current.location == 67) {
                vars.chapter++;
                return true;
            }
            break;
        case 4:
            if (current.location == 50) {
                vars.chapter++;
                return true;
            }
            break;
        case 5:
            if (current.location == 57) {
                vars.chapter++;
                return true;
            }
            break;
        case 6:
            if (current.location == 33) {
                vars.chapter++;
                return true;
            }
            break;
    }
    if (current.location == 160 && old.cutscene == 0 && current.cutscene == 1)
        return true;
}
