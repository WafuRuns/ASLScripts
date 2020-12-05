state("Øež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184;
    int levelLoading : 0x65270, 0xB0, 0x494;
}

state("Řež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184;
    int levelLoading : 0x65270, 0xB0, 0x494;
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
