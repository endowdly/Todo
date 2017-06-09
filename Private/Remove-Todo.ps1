# -----------------------------------------------------------------------------
# Todo/Remove-Todo
# ------------------------------------------------------------------------------
# ! Removes Item line from Task
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> Path line Item deleted
# ----------------------------------------------------------------------------- 

function Remove-Todo {
    # -> Delete
    if (-not $Term) {

        if ($TODOTXT_FORCE) {
            $answer = prompt "Delete '${Todo}'?" 'y'   # No check
        }
        else {
            $answer = 'y'
        }

        if ($answer -eq 'y') {

            if ($TODOTXT_PRESERVE_LINE_NUMBERS) {

                # Delete line (changes line numbers)
                Get-Content $Path | 
                    Where-Object { $_.ReadCount -ne $Item } |
                    Set-Content $Path
            }
            else {
                # Leave blank line behind (preserves line numbers)
                Get-Content $Path |
                    ForEach-Object {
                        if ($_.ReadCount -eq $Item) { '' } else { $_ }
                    } |
                    Set-Content $Path
            }

            if ($TODOTXT_VERBOSE) {
                success "TODO: $Item deleted."
            }
        }
        else {
            failure "TODO: No tasks were deleted."
        }
    }# _if
    else {
        Get-Content $Path |
            ForEach-Object {
                if ($_.ReadCount -eq $Item)
                    { $_ -replace "\s+?$Term\s+?", ' ' }
                else
                    { $_ }
            } |
            Set-Content $Path

        $newTodo = Get-Todo

        if ($Todo -eq $newTodo) {
            if ($TODOTXT_VERBOSE) { "$Item $Todo"; }
            die "TODO: $Term not found; no removal done"
        }

        if ($TODOTXT_VERBOSE) {
            "$Item $Todo -> $Item $newTodo" | ColorWord '->' DarkCyan
            success "TODO: Removed '$Term' from task."
        }
    }# fi
}

# __END__
