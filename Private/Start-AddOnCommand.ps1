# -----------------------------------------------------------------------------
# Todo/Stat-AddOnCommand
# ------------------------------------------------------------------------------
# ! Searches actions.d for modular add on scripts
# < string
# > void
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> actions.d may be created if it does not exist; Command will be run
# ----------------------------------------------------------------------------- 
# TODO: Make this more robust. Allow this to find a file that either contains
#       a command in text, get the content, and run it, or as it currently 
#       works. 

function Start-AddOnCommand ($Command) {
    # -> addon dir
    $addOnPath = Join-Path $TODO_DIR actions.d

    # => test dir 
    $addOnPathExists? = Test-Path 

    # => build dir
    if (-not $addOnPathExists?) {
       warning 'Action directory does not exist, building. . .'
       try {
           New-Item $addOnPath -ItemType Directory > $null
           success 'Addon directory built'
       }
       catch {
          failure 'Addon directory not built' 
       } 
    }

    # -> find command
    $commandPath = Join-Path $addOnPath -Resolve $commandAsPath
    $commandExists? = Test-Path $commandPath -PathType Leaf

    # => run command
    if ($commandExists?)
        { &$commandPath } 
    else
        { failure "Command '$Command' does not exist" }
}