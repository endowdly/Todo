# -----------------------------------------------------------------------------
# Todo/Out-TodoPriorities
# ------------------------------------------------------------------------------
# ! Displays all lines of Path matching Priority
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> None
# ----------------------------------------------------------------------------- 

function Out-TodoPriorities () {
    # -> define action
    $getCount = { $content.Count }

    # -> color of priority
    $1 = Get-Variable "PRI_$Priority" -ErrorAction SilentlyContinue
    $2 = Get-Variable DefaultColor -ErrorAction SilentlyContinue
    # null coalescing by using array comprehension
    $clr = ($1, $2 -ne $null)[0]

    # => get all content and count
    $content = Get-Content $Path | Where-Object { $_ }
    $totalCount = &$getCount

    # -> Select Properties
    $PriorityFromPath = @{
        Path = $Path
        Pattern = "\($Priority\)"
        AllMatches = $true
        OutVariable = 'content'
    }
    # => Fetch and filter pris
    Select-String @PriorityFromPath | Write-Host -ForegroundColor $clr.Value

    # => Report
    if ($TODOTXT_VERBOSE) {
        $tasksCount = &$getCount
        '--';
        "TODO: $tasksCount of $totalCount tasks shown";
    }
}

# __END__
