# -----------------------------------------------------------------------------
# Todo/Complete-Todo
# ------------------------------------------------------------------------------
# ! Marks a Todo as complete by changing the string
# < int
# > void
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> string altered
# ----------------------------------------------------------------------------- 

function Complete-Todo {
    # -> Execute
    if ($Todo -notmatch '^x') {
        $now = Get-Date -UFormat '+%Y-%m-%d'
        Get-Content $Path |
            ForEach-Object {
                if ($_.ReadCount -eq $Item)
                    { "x $now $Todo" }
                else
                    { $_ }
            } |
            Set-Content $Path

        if ($TODOTXT_VERBOSE) {
            # "$Item $Todo";
            success "TODO: $Item marked as done"
        }
    }
    else {
        failure "TODO: $Item is already marked done"
    }

    if ($TODOTXT_AUTO_ARCHIVE) {
        #  Recursively invoke the function to allow overriding of the archive
        #  action
        Invoke-Todo -Archive
    }
}

# __END__
