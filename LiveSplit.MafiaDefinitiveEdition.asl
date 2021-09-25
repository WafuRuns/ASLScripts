state("mafiadefinitiveedition", "1")
{
    byte loading : 0x643F9F0, 0x10, 0x18;
    string10 chapter : 0x63D92B0, 0x20;
}

state("mafiadefinitiveedition", "2")
{
    byte loading : 0x6432E60, 0x10, 0x18;
    string10 chapter : 0x63CC4B8, 0x20;
}

state("mafiadefinitiveedition", "3")
{
    byte loading : 0x6442E60, 0x10, 0x18;
    string10 chapter : 0x63DC4B8, 0x20;
}

state("mafiadefinitiveedition", "4")
{
    byte loading : 0x6442E70, 0x10, 0x18;
    string10 chapter : 0x63DC4C8, 0x20;
}

startup
{
    settings.Add("ver", true, "Version (pick only one!)");
    settings.Add("verup", false, "Unpatched (25/9/2020)", "ver");
    settings.Add("ver7102020", false, "Patch 1 (7/10/2020)", "ver");
    settings.Add("ver11112020", false, "Patch 2 (11/11/2020)", "ver");
    settings.Add("ver2592021", true, "Patch 3 (25/9/2021)", "ver");
    vars.chapters = new List<string>() {"0_taxi_cp_", "0_molotov_", "0_motel_cp",
                                        "0_race_cp_", "0_sarah_cp", "0_hoodlums",
                                        "0_brothel_", "00_farm_cp", "10_omerta_",
                                        "20_mansion", "30_parking", "40_salieri",
                                        "50_boat_cp", "60_harbor_", "70_plane_c",
                                        "80_sniper_", "90_cigars_", "00_bank_cp",
                                        "10_gallery"};
}

init
{
    vars.chapterNumber = timer.CurrentSplitIndex;
    if (vars.chapterNumber < 0)
        vars.chapterNumber = 0;
    if (settings["verup"]) {
        version = "1";
        return;
    }
    if (settings["ver7102020"]) {
        version = "2";
        return;
    }
    if (settings["ver11112020"]) {
        version = "3";
        return;
    }
    if (settings["ver2592021"]) {
        version = "4";
        return;
    }
}

update
{
    print(chapter);
    print(loading.ToString());
}

start
{
    if (current.chapter == "t_omg)") {
        vars.chapterNumber = 0;
        return true;
    }
}

split
{
    if (vars.chapters[vars.chapterNumber] == current.chapter) {
        vars.chapterNumber++;
        return true;
    }
}

isLoading
{
    return current.loading == 1;
}
