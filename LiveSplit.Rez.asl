state("Øež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184;
    int levelLoading : 0x159B4, 0x338, 0x164, 0xF88;
}

state("Řež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184;
    int levelLoading : 0x159B4, 0x338, 0x164, 0xF88;
}

start
{
    return current.inGame != old.inGame;
}

split
{
    return (current.mission != old.mission) && current.mission != 1;
}

isLoading
{
    return !current.inGame || current.levelLoading == 0;
}
