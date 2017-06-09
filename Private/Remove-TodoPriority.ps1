# -----------------------------------------------------------------------------
# Todo/Remove-TodoPriority
# ------------------------------------------------------------------------------
# ! Removes priority from line Item of Path
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> Path line Item stripped of priority
# ----------------------------------------------------------------------------- 

function Remove-TodoPriority {

    # -> Execute
    if ($Todo -match '\(?\)*') {
        Get-Content $Path |
            ForEach-Object {
                if ($_.ReadCount -eq $Item)
                    { $_ -replace '^(.) ' }
                else
                    { $_ }
            } |
            Set-Content $Path

        if ($TODOTXT_VERBOSE) {
            # "$Item $Todo";
            success "TODO: $Item deprioritized."
        }
    }
    else {
        die "TODO: $Item is not prioritized."
    }
}

# __END__
