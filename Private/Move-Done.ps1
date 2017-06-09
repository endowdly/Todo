# -----------------------------------------------------------------------------
# Todo/Move-Done
# ------------------------------------------------------------------------------
# ! Moves a line from a TODO_FILE to DONE_FILE
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> TODO_FILE exists
# Post -> Line specified moves from TODO_FILE and is appended to DONE_FILE
# ----------------------------------------------------------------------------- 

function Move-Done {
    # -> Fetch not blank lines
    $todoContent = Get-Content $TODO_FILE | Where-Object { $_ }

    # -> Fetch Done and Not Done lines
    $done = $todoContent -match '^x '
    $notDone = $todoContent -notmatch '^x '

    # => Move Done lines (Add)
    Add-Content -Path $DONE_FILE -Value $done

    # => Remove Done lines (Set) and defragment
    Get-Content $TODO_FILE |
        Where-Object { $_ } | 
        Where-Object { $notDone -contains $_ } | 
        Set-Content $TODO_FILE

    # => Report
    if ($TODOTXT_VERBOSE) { success "TODO: $TODO_FILE archived" }
}

# __END__
