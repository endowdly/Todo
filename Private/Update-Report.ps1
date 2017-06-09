# -----------------------------------------------------------------------------
# Todo/Update-Report
# ------------------------------------------------------------------------------
# ! Updates the REPORT_FILE
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> REPORT_FILE exists
# Post -> REPORT_FILE updated
# ----------------------------------------------------------------------------- 

function Update-Report () {

    # -> Recursive archive first
    Invoke-Todo -Archive

    # -> Get tasknumber and report info
    $total = Get-TaskNumber $TODO_FILE
    $done = Get-TaskNumber $DONE_FILE
    $newData = "$total $done"
    $lastReport = Get-Content $REPORT_FILE | Select-Object -Last 1
    $lastData = $lastReport -replace '^[^ ]* '

    if ($lastData -eq $newData) {
        $lastReport;
        if ($TODOTEXT_VERBOSE) { verbose "TODO: Report file is up-to-date" }
    }
    else {
        $newReport = "$(Get-Date -UFormat +%Y-%m-%dT%T) $newData"
        Add-Content -Path $REPORT_FILE -Value $newReport > $null
        $newReport;

        if ($TODOTEXT_VERBOSE) { success "TODO: Report file updated" }
    }
}

# __END__
