# -----------------------------------------------------------------------------
# Todo/Add-Todo
# ------------------------------------------------------------------------------
# ! Adds a string to TODO_FILE
# < string
# > void
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> Text added to Path with proper format
# ----------------------------------------------------------------------------- 

function Add-Todo ($File) {
    # _add()
    $fileExists? = Test-Path $file -PathType Leaf
    if (-not $fileExists?) {
        warning "File $File does not exist"
        $create? = prompt "Create file ${File}?" 'y'

        if ($create? -ne 'y') { die 'Nothing added' }
    }
    $todoText = $Text
    if ($Project) { $todoText += " +$Project" }        # append project
    if ($Context) { $todoText += " @$Context" }        # append context

    if ($TODOTXT_DATE_ON_ADD) {
        $now = Get-Date -UFormat '+%Y-%m-%d'
        if ($Priority)
            { $todoText = '({0}) {1} {2}' -f $Priority, $now, $todoText }
        else
            { $todoText = '{0} {1}' -f $now, $todoText }
    }
    elseif ($Priority) {
        $todoText = '({0}) {1}' -f $Priority, $todoText
    }

    $todoToAdd = $todoText | CleanInput
    Add-Content -Path $File -Value $todoToAdd

    if ($TODOTXT_VERBOSE) {
        $taskNumber = Get-TaskNumber $File
        "$taskNumber $todoToAdd";
        success "$(getPrefix $File): $taskNumber added"
    }
}# __Add-Todo

# __END__
