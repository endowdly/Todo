# -----------------------------------------------------------------------------
# Todo/Read-TodoConfig
# ------------------------------------------------------------------------------
# ! This reads the config file for todo.sh or todo.cfg
#    It treats all bash variables as environment variables so it should only
#    be used for todo.sh or similar CLI applications.
# < void
# > void
# ^ string array
# -----------------------------------------------------------------------------
# Pre  -> env:TODOTXT_CFG_FILE defined
# Post -> config file executed even if it is a bash file
# ----------------------------------------------------------------------------- 

function Read-TodoConfig {

    # => Define vars
    $contents = Get-Content $TODOTXT_CFG_FILE -ErrorAction Stop
    $actions = $contents | Where-Object { $_ -notmatch '#' }

    # => Execute uncommented lines in config
    foreach ($action in $actions) {
        $action = $action -replace '\$','$env:'   # bash -> posh
        $action = [ScriptBlock]::Create($action)  # converts a string to sb
        try { &$action } catch { $actionErr += ,$action.ToString() }
    }

    # => Report errors
    if ($actionErr) {
        warning 'The following commands could not be parsed/configured:'
        foreach ($err in $actionErr) { Write-Host $err }
    }
}

# __END__
