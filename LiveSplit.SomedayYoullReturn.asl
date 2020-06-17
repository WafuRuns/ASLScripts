state("TheForest-Win64-Shipping", "1.2.1")
{
    bool loading : 0x2F16D48;
    byte chapter : 0x2F39318, 0xD80, 0x7B0;
}

state("TheForest-Win64-Shipping", "1.2.0")
{
    bool loading : 0x2F16C48;
    byte chapter : 0x2F39218, 0xD80, 0x7B0;
}

state("TheForest-Win64-Shipping", "1.1.0")
{
    bool loading : 0x2D09035;
    byte chapter : 0x2F39198, 0xD80, 0x7B0;
}

startup
{
    settings.Add("ver", true, "Version (pick only one!)");
    settings.Add("ver110", true, "1.1.0", "ver");
    settings.Add("ver120", false, "1.2.0", "ver");
    settings.Add("ver121", false, "1.2.1", "ver");
}

init
{
    if(settings["ver110"]) {
        version = "1.1.0";
        return;
    }
    if(settings["ver120"]) {
        version = "1.2.0";
        return;
    }
    if(settings["ver121"]) {
        version = "1.2.1";
        return;
    }
}

split
{
    return current.chapter != old.chapter;
}

isLoading
{
    return current.loading;
}
