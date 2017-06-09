# bash -> posh

function Get-FileBaseName {
    foreach ($arg in $args) {
        $file += @($arg -as [System.IO.FileInfo])
    }
    return $file.BaseName
}

# __END__
