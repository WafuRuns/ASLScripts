state("mafiadefinitiveedition")
{
    byte loading : 0x643F9F0, 0x10, 0x18;
    string10 chapter : 0x63D92B0, 0x20;
}

startup
{
    vars.chapters = new List<string>() {"0_taxi_cp_", "0_molotov_", "0_motel_cp",
                                        "0_race_cp_", "0_sarah_cp", "0_hoodlums",
                                        "0_brothel_", "00_farm_cp", "10_omerta_",
                                        "20_mansion", "30_parking", "40_salieri",
                                        "50_boat_cp", "60_harbor_", "70_plane_c",
                                        "80_sniper_", "90_cigars_", "00_bank_cp",
                                        "10_gallery"};
    vars.chapterNumber = 0;
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
