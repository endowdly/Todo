# -----------------------------------------------------------------------------
# Todo/Reset-Todo
# ------------------------------------------------------------------------------
# ! Replaces line Item of Path with new Text. Preserves Priority and Date, if 
#   they exist. This is a heavily rewritten replaceOrPrepend() without the 
#   prepend action
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> line Item of Path replaces with Text
# ----------------------------------------------------------------------------- 

function Reset-Todo {
    # replaceOrPrepend()

    # -> Retrieve existing priority and prepended date
    $local:priority = -split $Todo -match '\(.\)'
    $date = -split $Todo -match '\(?\d{2,4}-\d{1,2}-\d{1,2}\)?'

    # -> Make the replacements and set the Path
    Get-Content $Path |
        ForEach-Object {
            if ($_.ReadCount -eq $Item)
                { "$local:priority $date $Text" }
            else
                { $_ }
        } |
        Set-Content $Path

    # -> Report
    if ($TODOTXT_VERBOSE) {
        $newTodo = Get-Todo
        success "TODO: Replaced task with: $Item $newTodo"
    }
}# __func

# __END__ 
