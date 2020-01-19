state("LustForDarkness") {}

init
{
    vars.loading = false;
    vars.logFile = @"%userprofile%\AppData\LocalLow\Movie Games Lunarium\Lust For Darkness\lfd.log";
    vars.logFile = Environment.ExpandEnvironmentVariables(vars.logFile);
}

update
{
    vars.reader = new StreamReader(new FileStream(vars.logFile, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
    vars.line = vars.reader.ReadLine();
    if (vars.line == "False") vars.loading = false;
    else vars.loading = true;
    vars.reader.Close();
}

isLoading
{
    return vars.loading;
}
