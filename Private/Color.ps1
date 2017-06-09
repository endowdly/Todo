# -----------------------------------------------------------------------------
# Color
# ------------------------------------------------------------------------------
# ! colors a simple match string in console
# < string array, ConsoleColor array <-> string, switch <-> bool
# > void
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> writes to console, returns nothing
# ----------------------------------------------------------------------------- 
# Example: 'a string here' | Color -Word String -Color Red
# TODO: Add a regex capable search

filter Color {
    param (
        [Alias('String', 'Word', 'Characters')]
        [String[]] $Text,

        [Alias('As')]
        [ConsoleColor[]] $Color,

        [Switch] $NoNewline
    ) 

    $line = $_
    $comparisonType = [System.StringComparison]::InvariantCultureIgnoreCase

    foreach ($word in $Text) {
        $idx = [Array]::IndexOf($Text, $word)    # Version 2 compatible   
        $indexOfWord = $line.IndexOf($word, $comparisonType)

        while ($indexOfWord -ge 0) {
            Write-Host $line.Substring(0, $indexofWord) -NoNewline
            Write-Host $line.Substring($indexOfWord, $word.Length) -NoNewline -ForegroundColor $Color[$idx]
            $used = $word.Length + $indexOfWord
            $remain = $line.Length - $used
            $line = $line.Substring($used, $remain)
            $indexOfWord = $line.IndexOf($word, $comparisonType)
        }
    }
    if ($NoNewline) { Write-Host $line -NoNewline } else { Write-Host $line }
}

# __END__
