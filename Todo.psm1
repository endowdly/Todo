#------------------------------------------------------------------------------
#                           Todo Module
#------------------------------------------------------------------------------

# --- Get Files ---------------------------------------------------------------
$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1)
$Files = $Public + $Private

# --- Source Files ------------------------------------------------------------
foreach ($file in $Files) { 
    try
        { . $file.FullName }
    catch
        { $loadErr += ,$file.InvocationInfo.ScriptName }
}

if ($loadErr) {
    Write-Host 'Failed to load: ' -ForegroundColor Red
    foreach ($err in $loadErr) { Write-Host $err }

    throw 'Todo -> fatal load error; aborting module import'
}
# --- Export Public Functions and Variables -----------------------------------
$functionsToExport = $Public | ForEach-Object { $_.BaseName }
Set-Alias Todo Invoke-Todo
Export-ModuleMember -Function $functionsToExport -Alias Todo

# --- Private Module Functions and Variables ---------------------------------
# -> vars
$lf = 10 -as [char]
$cr = 13 -as [char]
$tab = 9 -as [char]
$sp = 32 -as [char]
# $TODO_DIR = Join-Path $HOME todo
# $TODO_FILE = Join-Path $TODO_DIR todo.txt
# $DONE_FILE = Join-Path $TODO_DIR done.txt
# $REPORT_FILE = Join-Path $TODO_DIR report.txt
$TempConfig = Join-Path $PSScriptRoot -Resolve CONFIG*

# -> env
$defaults = @{
    TODOTXT_VERBOSE = $true
    TODOTXT_PLAIN = $false
    TODOTXT_CFG_FILE = "$HOME/.todo/config"
    TODOTXT_FORCE = $false
    TODOTXT_PRESERVE_LINE_NUMBERS = $true
    TODOTXT_AUTO_ARCHIVE = $true
    TODOTXT_DATE_ON_ADD = $false
#   TODOTXT_SORT_COMMAND = ([int]$env:TODOTXT_SORT_COMMAND, env LC_COLLATE = C sort -f -k2
#   TODOTXT_DISABLE_FILTER = if (-not $env:TODOTXT_DISABLE_FILTER) { $null };
#   TODOTXT_FINAL_FILTER = $env:TODOTXT_FINAL_FILTER, cat
#   TODOTXT_GLOBAL_CFG_FILE = if (-not $env:TODOTXT_GLOBAL_CFG_FILE) { "/etc/todo/config" } else { $env:TODOTXT_GLOBAL_CFG_FILE };
    PRI_A = 'Red'
    PRI_B = 'Yellow'
    PRI_C = 'Green'
    PRI_X = 'White'
    COLOR_PROJECT = 'Cyan'
    COLOR_CONTEXT = 'Red'
    COLOR_DONE = 'Gray'
}

# Mod names
# HACK: This may need to be optimized (removed) because it isn't used much
$TOOD_FULL_SH = Join-Path $PSScriptRoot/Public -Resolve Invoke-Todo*
$TODO_SH = Get-FileBaseName $TODO_FULL_SH

# Default base color
$DefaultColor = $Host.UI.RawUI.ForegroundColor 2> $null
$DefaultColor = ($DefaultColor, 'Gray' -ne -1)[0]

# apply env => 
$defaults.GetEnumerator() |
    ? { $_.Value -ne $null } |
    % { Set-Variable $_.Key $_.Value }

# -> Aliases
Set-Alias replaceOrPrepend Reset-Todo
Set-Alias die Exit-Todo
Set-Alias dieWithHelp Exit-WithHelp
Set-Alias getPrefix Get-TodoPrefix
Set-Alias export Export-EnvironmentVariable
Set-Alias basename Get-FileBaseName

# -> Functions
filter CleanInput {
    # cleaninput()
    $_ -replace "$cr|$lf"
}

if (Get-Module PSConsolePrettyPrint) {
    function success { Write-Success $args }
    function failure { Write-Failure $args }
    function verbose { Write-ConsoleVerbose $args }
    function warning { Write-ConsoleWarning $args }
    function prompt { Write-Prompt $args[0] $args[1] }
}
else {
    function success { Write-Host $args[0] }
    function failure { Write-Error $args[0] }
    function verbose { Write-Verbose $args[0] }
    function warning { Write-Warning $args[0] }
    function prompt { Read-Host $args[0] }
}

# --- Module Specific Actions -------------------------------------------------

# => read config or install
try {
    Read-TodoConfig
}
catch {
    Install-Todo
    Read-TodoConfig
}
finally {
    success 'TODO Ready'
}

# __END__
