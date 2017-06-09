# -----------------------------------------------------------------------------
# Write-Color
# ------------------------------------------------------------------------------
# ! Writes Text to host as Color with options
# < string array, ConsoleColor array, int, int, int
# > void
# -----------------------------------------------------------------------------
# Pre  -> None
# Post -> None
# ----------------------------------------------------------------------------- 

function Write-Color {

    param (
        [String[]] $Text,
        [ConsoleColor[]] $Color,
        [Int] $StartTab = 0,
        [Int] $LinesBefore = 0,
        [Int] $LinesAfter = 0
    )

    begin {
        $DefaultColor = $Host.UI.RawUI.ForegroundColor 2> $null
        $DefaultColor = ($DefaultColor, 'Gray' -ne -1)[0]

        function Write-NewLine {
            Write-Host $lf -NoNewline
        }

        function Write-Tab {
            Write-Host $tab -NoNewline
        }
    }

    process {

        # Add empty line before
        if ($LinesBefore) {
            1..$LinesBefore |
                Foreach-Object { Write-Newline }
        }

        # Add tabs before
        if ($StartTab) {
            1..$StartTab |
                Foreach-Object { Write-Tab }
        }

        if ($Color.Count -ge $Text.Count) {
            0..($Text.Count - 1) |
                Foreach-Object { Write-Host $Text[$_] -ForegroundColor $Color[$_] -NoNewline }
        }
        else {
              0..($Color.Count - 1) |
                  ForEach-Object { Write-Host $Text[$_] -ForegroundColor $Color[$_] -NoNewline }

              $Color.Count..($Text.Count - 1) |
                  ForEach-Object { Write-Host $Text[$_] -ForegroundColor $DefaultColor -NoNewline }
         }

        # Add empty line after

        Write-Host  # linefeed

        if ($LinesAfter) {
            1..$LinesAfter |
                Foreach-Object { Write-Newline }
        }
    }# __process

    end {
        $sColor = ('','s')[$Color.Count -gt 1]
        $sText = ('','s')[$Text.Count -gt 1]

        Write-Verbose "$($Color.Count) item$sColor returned for $($Text.Count) item$sText"
    }
}# __fun

# __END__
