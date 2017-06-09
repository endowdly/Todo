# -----------------------------------------------------------------------------
# Todo/Out-AllFiles
# ------------------------------------------------------------------------------
# ! Displays all lines of TODO_FILE and DONE_FILE
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> None
# ----------------------------------------------------------------------------- 

function Out-AllFiles {
    # -> get count
    $getFileCount = { $fileContent.Count }

    # -> Fetch files
    $todoFile = Get-Content $TODO_FILE |
        Where-Object { $_ } -OutVariable fileContent |
        Select-Object -Last 10
    $todoLength = &$getFileCount
    $doneFile = Get-Content $DONE_FILE |
        Where-Object { $_ } -OutVariable fileContent |
        Select-Object -Last 10
    $doneLength = &$getFileCount

    # -> Display contents
    $todoFile, $doneFile | Write-Output | Out-Host -Paging 

    # -> Display stats
    if ($TODOTXT_VERBOSE) {
        $s = if ($todoLength -gt 1) { 's' }
        $todoReport = "TODO: {0} of {1} task$s shown" -f $todoFile.Count, $todoLength
        $s = if ($doneLength -gt 1) { 's' }
        $doneReport = "DONE: {0} of {1} task$s shown" -f $doneFile.Count, $doneLength
        $s = if ($doneLength + $todoLength -gt 1) { "s" }
        $totalReport = "TOTAL: {0} of {1} task$s shown" -f ($doneFile.Count + $todoFile.Count), 
                                                           ($todoLength + $doneLength)
        '--';
        $todoReport;
        $doneReport;
        $totalReport;
    }
}

# __END__ 
