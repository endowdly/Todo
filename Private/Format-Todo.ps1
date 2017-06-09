# -----------------------------------------------------------------------------
# Todo/Format-Todo
# ------------------------------------------------------------------------------
# ! Formats the contents of TODO_FILE for output
# < void
# > int
# -----------------------------------------------------------------------------
# Pre  -> env:TODO_FILE defined
# Post -> count of returned lines as int
# ----------------------------------------------------------------------------- 

function Format-Todo {
    # Parameters:    $1: todo input file; when empty formats stdin
    #                $2: ITEM# number width; if empty auto-detects from $1 / $TODO_FILE.
    # Precondition:  None
    # Postcondition: $NUMTASKS and $TOTALTASKS contain statistics (unless $TODOTXT_VERBOSE=0).
    
    # -> vars
    # TODO: add the ability to change these parameters
    $paging = 10
    $sortExpression = { $_.SubString(0, 2) -as [int] }

    if ($TODOTXT_DISABLE_FILTER) {        # if no 'filtering'
        $finalFilter = { Out-Host -Paging }   # page
    }
#   elseif ($1) {
#       $FinalFilter = { Select-String $1 }
#   }
    # TODO: add this feature by using the unimplimented ColorWord Filter
    #  that will allow the filter to run and the colorword filter to be
    #  run last in the pipeline
    else {
        $finalFilter = { Out-Null }           # do nothing
    }
    $fileContent = Get-Content $Path

    if ($HideProjectExpression)
        { $fileContent = $fileContent -replace $HideProjectExpression }
    if ($HideContextExpression)
        { $fileContent = $fileContent -replace $HideContextExpression }
    if ($HidePriorityExpression)
        { $fileContent = $fileContent -replace $HidePriorityExpression }

    $fileContent |
        Where-Object { $_ } |
        Select-Object -Last $paging -OutVariable taskCount |
        ForEach-Object { $_.ReadCount.ToString() + ": $_" } |
        Sort-Object { $sortExpression } |
        ForEach-Object {
            if ($TODOTXT_DISABLE_FILTER) {
                continue
            }
            else {
                # --- Text
                $done = $_ -match '^x '
                $date = -split $_ -match '\d{2,4}-\d{1,2}-\d{1,2}'
                $priority = -split $_ -match '\([A-Z]\)' -as [string]
                $project = -split $_ -match '[+]\w+'
                $context = -split $_ -match '[@]\w+'
                $lineNumber = -split $_ -match '\d+:'
                $rest = -split $_ | Where-Object {
                    $_ -ne $context -and
                    $_ -ne $project -and
                    $_ -ne $date -and
                    $_ -ne $priority -and
                    $_ -ne $lineNumber }

                $final = $lineNumber, $date, $priority, $rest, $context, $project -as [string[]] | 
                            Where-Object { $_ } |
                            ForEach-Object { $_ + $sp }

                # --- Colors
                $clr = Get-Variable ('PRI_' + $priority[1]) 2> $null
                $defaultClr = Get-Variable PRI_X -ErrorAction Ignore
                $clr = ($clr.Value, $defaultClr.Value -ne $null)[0]
                $dateColor = if ($date) { 'Cyan' } else { $null }
                $priorityColor = if ($priority) { $clr } else { $null }
                $contextColor = if ($context) { $COLOR_CONTEXT } else { $null }
                $projectColor = if ($project) { $COLOR_PROJECT } else { $null }
                $lnColor = if ($lineNumber) { 'DarkMagenta' } else { $null }
                $restColor = if ($rest) { $DefaultColor } else { $null }

                $colors = $lnColor, $dateColor, $priorityColor, $restColor, $contextColor, $projectColor |
                    Where-Object { $_ }

                if ($done) {
                    $final = $_
                    $colors = $COLOR_DONE
                }

                if ($colors.Length -ne $final.Length -or $TODOTXT_PLAIN) {

                    # Write-Verbose 'Formatting Error detected, defaulting to Plain Mode'

                    $colors = $DefaultColor
                }

                # --- Output
                Write-Color $final -Color $colors
            }
        } | Invoke-Command $finalFilter
#           ^^^^^^^^^^^^^^
#  using invoke here allows the pipeline elememt to be passed into the
#  scriptblock as a whole -- lets out-host function normally
#  when ColorWord is implemented, this will not be last
    
    return $taskCount.Count

}

# __END__
