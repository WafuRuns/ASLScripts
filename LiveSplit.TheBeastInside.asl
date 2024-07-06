state("TheBeastInside-Win64-Shipping", "1.03")
{
    byte loading : 0x2C64900, 0xC0, 0x8, 0x2C8;
    string32 chapter: 0x2C4DA58, 0x7C8, 0x28;
    byte control : 0x2C4EED0, 0x30, 0x348, 0xBA5;
}

state("TheBeastInside-Win64-Shipping", "1.05")
{
    byte loading : 0x2BFBA60, 0xC0, 0x8, 0x2C8;
    string32 chapter: 0x2BE4BD8, 0x7C8, 0x28;
    byte control : 0x2BE6050, 0x30, 0x348, 0xBA5;
}

startup
{
    vars.missions = new Dictionary<string, string> {
        {"Chapter02/DV_C02", "Chapter 2"},
        {"Chapter03/DV_C03", "Chapter 3"},
        {"Chapter04/DV_C04", "Chapter 4"},
        {"Chapter05/DV_C05", "Chapter 5"},
        {"Chapter06/DV_C06", "Chapter 6"},
        {"Chapter07/DV_C07", "Chapter 7"},
        {"Chapter08/DV_C08", "Chapter 8"},
        {"Chapter09/DV_C09", "Chapter 9"},
        {"Chapter10/DV_C10", "Chapter 10"},
        {"Chapter11/DV_C11", "Chapter 11"},
        {"Chapter12/DV_C12", "Chapter 12"},
        {"Chapter13/DV_C13", "Chapter 13"}
    };
    foreach (var tag in vars.missions) {
        settings.Add(tag.Key, true, tag.Value);
    }
    settings.Add("v103", false, 'Version 1.03');
}

init
{
    if (settings["v103"]) {
        version = "1.03";
    } else {
        version = "1.05";
    }
    vars.endSplit = 0;
}

update
{
    if (current.chapter == "Chapter13/DV_C13" && old.control == 0 && current.control == 1)
        vars.endSplit++;
}

start
{
    return current.chapter != old.chapter && current.chapter == "Chapter01/DV_C01";
}

split
{
    if (vars.endSplit > 3) {
        vars.endSplit = 0;
        return true;
    }
    if (current.chapter != old.chapter) {
        if (settings[current.chapter]) return true;
    }
}

isLoading
{
    return current.loading == 1 || current.loading == null;
}

exit
{
    timer.IsGameTimePaused = true;
}
