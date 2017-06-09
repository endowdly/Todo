# bash -> posh

function Exit-Todo {
    # die()

#   echo "$@"
    failure "$args"

#   exit 1   # May exit the shell
    break 2  # This will exit the parent function
}

# __END__
