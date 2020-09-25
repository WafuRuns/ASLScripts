state("mafiadefinitiveedition")
{
    bool loading : 0x648F0B8, 0x48;
}

isLoading
{
    return current.loading;
}
