state("Øež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184; 
}

state("Řež")
{
    int mission : 0x7CA1C;
    bool inGame : "WMADMOD.DLL", 0x9D184;
}

start
{
    return current.mission != old.mission;
}

split
{
    return current.mission != old.mission;
}

isLoading
{
    return !current.inGame;
}
