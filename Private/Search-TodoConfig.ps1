# -----------------------------------------------------------------------------
# Todo/Search-TodoConfig
# ------------------------------------------------------------------------------
# ! Checks most obvious path names for a todo config then.
#   Returns the path.
# < void
# > string
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> None
# ----------------------------------------------------------------------------- 

function Search-TodoConfig {
    $alts = "$HOME/todo.cfg",
            "$HOME/.todo.cfg",
            "$PSScriptRoot/todo.cfg",
            "TODOTXT_GLOBAL_CFG_FILE"

    $configFileExists? = Test-Path $TODOTXT_CFG_FILE -PathType Leaf

    if (-not $configFileExists?) {

        warning 'Could not find config file, searching...'

        foreach ($alt in $alts) {
            $fileExists? = Test-Path $alt -Type Leaf
            if ($fileExists?) {
                $script:TODOTXT_CFG_FILE = Resolve-Path $alt
                return
            }
        }
        throw '** Search failed **'
    }
}

# __END__
