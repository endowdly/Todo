# -----------------------------------------------------------------------------
# Todo/Move-Todo
# ------------------------------------------------------------------------------
# ! Moves a line from Path to Destination
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> Line specified moves from Path and is appended to Destination
# ----------------------------------------------------------------------------- 

function Move-Todo () {

    if ($TODOTXT_FORCE)
        { $answer = prompt "Move $Todo from $Path to $Destination?" 'y' }
    else
        { $answer = 'y' }

    if ($answer -eq 'y') {
        if ($TODOTXT_PRESERVE_LINE_NUMBERS) {
            # Delete line (changes line numbers)
            Add-Content -Path $Destination -Value $Todo
            Get-Content $Path |
                Where-Object { $_.ReadCount -ne $Item } |
                Set-Content $Path
        }
        else {
            # Leave blank lines
            Add-Content -Path $Destination -Value $Todo
            Get-Content $Path |
                ForEach-Object {
                    if ($_.ReadCount -eq $Item) { '' } else { $_ }
                } |
                Set-Content $Path
        }

        if ($TODOTXT_VERBOSE) {
            success "TODO: $Item moved from $Path to $Destination"
        }
    }
    else {
        failure "TODO: No tasks moved"
    }
}

# __END__
