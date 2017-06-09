# bash -> posh

function Get-TodoPrefix {
    # getPrefix()
    # Parameters:    $1: todo file; empty means $TODO_FILE.
    # Returns:       Uppercase FILE prefix to be used in place of "TODO:" where
    #                a different todo file can be specified.
    $1 = ($args[0], $env:TODO_FILE -ne $null)[0] -as [System.IO.FileInfo]
    $base = $1.BaseName
    $base.ToUpper() -replace '\.[^.]*$';
}

# __END__
