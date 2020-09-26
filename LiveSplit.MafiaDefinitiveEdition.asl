state("mafiadefinitiveedition")
{
    //bool loading : 0x648F0B8, 0x48; (old includes cutscenes)
    byte loading : 0x643F9F0, 0x10, 0x18;
}

start
{
    return old.loading == 2 && current.loading == 1;
}

isLoading
{
    return current.loading == 1;
}
