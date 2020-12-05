state("Øež")
{
    int mission : 0x7CA1C;
}

state("Řež")
{
    int mission : 0x7CA1C;
}

start
{
    return current.mission != old.mission;
}

split
{
    return current.mission != old.mission;
}