state("Øež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184;
    int levelLoading : 0x159B4, 0x340, 0x20, 0xB08;
}

state("Řež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184;
    int levelLoading : 0x159B4, 0x340, 0x20, 0xB08;
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
