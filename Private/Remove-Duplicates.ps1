# -----------------------------------------------------------------------------
# Todo/Remove-Duplicates
# ------------------------------------------------------------------------------
# ! Removes repeated lines from Path
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> Path file no longer contains duplicate lines
# ----------------------------------------------------------------------------- 

function Remove-Duplicates () {

    # -> Get task numbers
    $todoFile = Get-Content $Path | Where-Object { $_ }
    $oldTaskNum = $todoFile.Count

    # -> Execute
    if ($TODOTXT_PRESERVE_LINE_NUMBERS) {
        $fileWithoutDupes = $todoFile |
            Where-Object { $_ } |
            Sort-Object -Unique |
            Set-Content $Path
        
        $newTaskNum = $fileWithoutDupes.Count
    }
    else {
        $dupes = Get-Content $Path |
            Group-Object |
            Where-Object { -not ($_.Name -and $_.Count -gt 1) } |
            Select-Object Name 

        $fileWithoutDupes = Get-Content $Path |
            ForEach-Object {
                if ($dupes -contains $_) { '' } else { $_ }
            } |
            Set-Content $Path 
        
        $newTaskNum = $fileWithoutDupes.Count
     }

    # -> Report
    $duplicateNum = $oldTaskNum - $newTaskNum
    $s = if ($duplicateNum -gt 1) { 's' }

    if ($duplicateNum)
        { success "TODO: $duplicateNum duplicate task$s removed" }
    else
        { failure "TODO: No duplicate tasks found" }
}

# __END__ 
