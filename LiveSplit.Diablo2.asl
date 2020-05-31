state("Game", "1.14a")
{
    bool loading : 0x30A844;
    bool saving : 0x37D110;
    bool saving2 : 0x37DD30;
    bool inGame: 0x30A45C;
}

state("Game", "1.14b")
{
    bool loading : 0x30EF7C;
    bool saving : 0x370760;
    bool saving2 : 0x371380;
    bool inGame : 0x30EBC4;
}

state("Game", "1.14c")
{
    bool loading : 0x30DF7C;
    bool saving : 0x36F760;
    bool saving2 : 0x370380;
    bool inGame : 0x30DBC4;
}

state("Game", "1.14d")
{
    bool loading : 0x30F2C0;
    bool saving : 0x3792F8;
    bool saving2 : 0x3786D0;
    bool inGame : 0x30EE8C;
    bool inMenu : 0x379970;
}

update
{
    if (old.loading && !current.loading)
        vars.crashed = false;
}

init
{
    switch (modules.First().FileVersionInfo.FileVersion)
    {
        case "1.14.0.64":
            version = "1.14a";
            break;
        case "1.14.1.68":
            version = "1.14b";
            break;
        case "1.14.2.70":
            version = "1.14c";
            break;
        case "1.14.3.71":
            version = "1.14d";
            break;
    }
}

isLoading
{
    return (current.loading || ((current.saving || current.saving2) && !current.inGame && !current.inMenu)) && !vars.crashed;
}

exit
{
    timer.IsGameTimePaused = false;
    vars.crashed = true;
}
