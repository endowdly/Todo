# -----------------------------------------------------------------------------
# Todo/Update-Todo
# ------------------------------------------------------------------------------
# ! changes line Item of Path with Text
# < string
# > void
# -----------------------------------------------------------------------------
# Pre  -> Path exists
# Post -> line Item of Path updated with Text based on Action (pre|ap)pend
# ----------------------------------------------------------------------------- 

function Update-Todo ($Action) {
    # append with 'approved' verb
    # TODO: Find a better verb. >:|
    # -> Define Actions
    if ($Action -eq 'prepend') {
        $prependText = $Text
        
        try { 
            if ($prependText[-1] -ne $sp) { $prependText += $sp }
            $newTodo = $prependText + $Todo | CleanInput
            
            Get-Content $Path | 
                ForEach-Object {
                    if ($_.ReadCount -eq $Item) { $newTodo } else { $_ }
                } | 
                Set-Content $Path

            if ($TODOTXT_VERBOSE) {
                "$Item $(Get-Todo)";
                success "$(getPrefix $Path): $Item prepended with '$Text'"
            }
        }
        catch {
            die "$(getPrefix $Path): Error prepending task $Item"
        }
    }
     
    if ($Action -eq 'append') {
        $appendText = $Text

        try {
            $appendSpace = if ($appendText -match '^[,.;:]') { '' } else { ' ' }
            $newTodo = $Todo + $appendSpace + $appendText
        
            Get-Content $Path | 
                ForEach-Object { 
                    if ($_.ReadCount -eq $Item) { $newTodo } else { $_ }
                } | 
                Set-Content $Path

            if ($TODOTXT_VERBOSE) {
               "$Item $(Get-Todo)";
                success "$(getPrefix $Path): $Item append with '$Text'"
            }
        }
        catch {
            die "$(getPrefix $Path): Error appending task $Item"
        }
    }
}
 
# __END__
