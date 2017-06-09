# bash -> posh

function Write-TodoUsage {
    # usage()

    Write-Color "${lf}Usage: ",
                "$TodoSh [-fhpantvV] [-d todo_config] ",
                'action ',
                '[task_number] [task_description]' -Color Magenta, DarkCyan,
                    Yellow, DarkCyan

    Write-Color 'Try ',
                "$TodoSh -? ",
                'or ',
                "Get-Help $TodoSh -Full ",
                'for more information' -Color Gray, DarkCyan, Gray,
                    DarkCyan, Gray
#   exit 1    # May exit the shell
    break 1   # Kills the calling function
}

# __END__
