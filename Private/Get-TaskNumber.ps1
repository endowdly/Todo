function Get-TaskNumber ($File) {

    Get-Content -Path $File -ReadCount 100 |
        ForEach-Object { $count += ,$_.Count }

    return $count
}

# __END__
