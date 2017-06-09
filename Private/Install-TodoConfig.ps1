# -----------------------------------------------------------------------------
# Todo/Install-TodoConfig
# ------------------------------------------------------------------------------
# ! Runs and installs a TODO config file, bash compatible
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> CONFIG.ps1 exists
# Post -> CONFIG file copied to local todo directory
# ----------------------------------------------------------------------------- 

function Install-TodoConfig {
    # Execute => 
    if (Test-Path $TempConfig)
        { &$TempConfig }
    else  
        { throw 'FATAL ERROR could not locate temp CONFIG file' }

    # Inject => 
    $configContents = Get-Content $TempConfig
    $configPath = Join-Path $TODO_DIR config
    Set-Content -Path $configPath -Value $configContents
}