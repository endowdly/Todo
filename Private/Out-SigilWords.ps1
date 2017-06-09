# -----------------------------------------------------------------------------
# Todo/Out-SigilWords
# ------------------------------------------------------------------------------
# ! Displays lines containing Sigil
# < char
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> None
# ----------------------------------------------------------------------------- 

function Out-SigilWords ($Sigil) {

    # Gina offered the optional parsing of the done file if SOURCEVAR was
    #  defined. But, it was never altered or defined in the script and would
    #  not be UNLESS the user manually entered SOURCEVAR themselves. So I
    #  omit it here

    # -> Fetch the file contents
    $contents = Get-Content $Path

    # -> Filter out the sigil
    #eval "$(filtercommand 'cat "${FILE[@]}"' '' "$@")" | grep -o "[^ ]*${sigil}[^ ]\\+" | grep "^$sigil" | sort -u
    $contents |
        Where-Object { $_ -match "\$sigil" } |
        ForEach-Object { -split $_ -match "^\$sigil" } |
        Sort-Object -Unique
}

# __END__
