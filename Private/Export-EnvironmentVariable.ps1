# -----------------------------------------------------------------------------
# Todo/Export-EnvironmentVariable
# ------------------------------------------------------------------------------
# ! Adds a variable string to Env:
#   Can also assign a variable to env with bash like syntax
# < string array
# > void
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> arg and value is moved to Env: or arg is assigned in Env:
#         arg and value is also imported into variable:
# ----------------------------------------------------------------------------- 
# NOTE: This is done because so far, on nix, powershell pulls directly from the 
#  env provider, often casting the variable as a string. This causes serious
#  issues as the var is saved as a Powershell value >AS A STRING<. Things like
#  booleans get stuck in an env var as 'True' and 'False', and so cannot be 
#  pulled from the env and cast or compared properly. Allowing the module to 
#  read the config file and write to env, but still properly importing the 
#  env vars ensures full bash/posh interop.
# TODO: Make or include an ANSI color code reader than can read the BASH ANSI
#  colors.

function Export-EnvironmentVariable() {
    
    function getValue() {
        Get-Variable -ValueOnly $args
    }

    foreach ($arg in $args) {
        if ($arg -match '=') {
            $name, $value = $arg -split '='
            Set-Item -Force -Path Env:$name -Value $value > $null
            Set-Variable -Force -Name $name -Value $value -Scope Script > $null
        } 
        else {
            Set-Item -Force -Path Env:$arg -Value (getValue $arg) > $null
            Set-Variable -Force -Name $arg -Value (getValue $arg) -Scope Script > $null
        }
    }
}

# __END__
