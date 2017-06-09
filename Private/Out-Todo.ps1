# bash -> posh

function Out-Todo {
    # _list()
    
    # format => 
    $numTasks = Format-Todo

    # report =>
    if ($TODOTXT_VERBOSE) {
        $fileContents = Get-Content $Path | Where-Object { $_ }
        $totalTasks = $fileContents.Count
        $s = if ($totalTasks -gt 1) { 's '}
        '--';
        "$(getPrefix $Path): $numTasks of $totalTasks task$s shown";
    }
}

# __END__
