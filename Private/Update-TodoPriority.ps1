# -----------------------------------------------------------------------------
# Todo/Update-TodoPriority
# ------------------------------------------------------------------------------
# ! Changes or adds Priority to line Item of Path
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> line Item of Path now contains Priority
# ----------------------------------------------------------------------------- 

function Update-TodoPriority {
    # -> vars
    $newPri = $Priority
    
    # -> Execute
    if ($Todo -match '\(.\)') { $oldPri = $Todo[1] }   # grab the letter

    if ($oldPri -and ($oldPri -ne $newPri)) {
        Get-Content $Path |
            ForEach-Object {
                if ($_.ReadCount -eq $Item)
                    { $_ -replace '^\(.\) ', "($newPri) " } else { $_ }
            } |
            Set-Content $Path

        if ($TODOTXT_VERBOSE) { success "TODO: $Item prioritized from ($oldPri) to ($newPri)" }
    }
    elseif (-not $oldPri) {
        Get-Content $Path | 
            ForEach-Object { 
                if ($_.ReadCount -eq $Item) { "($newPri) $_" } else { $_ }
            } | 
            Set-Content $Path

        if ($TODOTXT_VERBOSE) { success "TODO: $Item prioritized ($newPri)" }
    }
    else {
        failure "TODO: $Item already prioritized ($newPri)"
    }
}

# __END__
