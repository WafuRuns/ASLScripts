state("RPG_RT")
{
    int level: 0xD2068, 0x4;
    int bossHP: 0xD2040, 0x8, 0x4, 0x0, 0x14;
}

start
{
    return current.level == 1 && old.level != 1;
}

split
{
    return current.level != old.level || (current.bossHP == 0 && old.bossHP > 0);
}
