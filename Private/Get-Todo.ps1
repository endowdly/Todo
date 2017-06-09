# bash -> posh

function Get-Todo {
    # getTodo()
    # getNewTodo()
    # -> Fetch todo
    $t = Get-Content $Path | Where-Object { $_.ReadCount -eq $Item }
    # -> Report
    if (-not $t)
        { failure "$(Get-TodoPrefix): No task $Item" }
    else
        { return $t }
}

# __END__
