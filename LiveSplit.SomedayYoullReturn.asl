//state("TheForest-Win64-Shipping") //1.2.0
//{
//    bool loading : 0x2F16C48;
//    byte chapter : 0x2F39218, 0xD80, 0x7B0;
//}

state("TheForest-Win64-Shipping") //1.1.0
{
    bool loading : 0x2D09035;
    byte chapter : 0x2F39198, 0xD80, 0x7B0;
}

split
{
    return current.chapter != old.chapter;
}

isLoading
{
    return current.loading;
}
