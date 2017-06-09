# bash -> posh

function Exit-WithHelp {
    # dieWithHelp()

    $1, ${@} = $args   # shift replacement
    switch ($1) {
        'help'      { Get-Help -Detailed Invoke-Todo }
        'shorthelp' { Invoke-Todo -? }
    }#esac

#   shift

    die ${@}   # <-
}

# __END__
