state("Game", "1.14a")
{
    byte loading : 0x388A2C;
    byte saving : 0x37D110;
    byte saving2 : 0x37DD30;
    byte inGame: 0x30A45C;
}

state("Game", "1.14b")
{
    byte loading : 0x39A8F0;
    byte saving : 0x370760;
    byte saving2 : 0x371380;
    byte inGame : 0x30EBC4;
}

state("Game", "1.14c")
{
    byte loading : 0x3998F0;
    byte saving : 0x36F760;
    byte saving2 : 0x370380;
    byte inGame : 0x30DBC4;
}

state("Game", "1.14d")
{
    byte loading : 0x3A2868;
    byte saving : 0x3792F8;
    byte saving2 : 0x3786D0;
    byte inGame : 0x30EE8C;
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
    return current.loading == 1 || ((current.saving == 1 || current.saving2 == 1) && current.inGame == 0);
}
