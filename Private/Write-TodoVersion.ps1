# bash -> posh

function Write-TodoVersion {
    (Test-Path $VERSION_FILE) -and (. $VERSION_FILE) -or   # <-
    ($TODO_VERSION = '2.10') > $null                     # <-

    # version ()

    Write-Color 'TODO.TXT Command Line Interface v',
                $todo_version -Color Gray, DarkCyan -LinesAfter 1

    Write-Color "First release: 5/11/2006
                Original conception by: Gina Trapani (http://ginatrapani.org)
                Contributors: http://github.com/ginatrapani/todo.txt-cli/network
	            License: GPL, http://www.gnu.org/copyleft/gpl.html
	            More information and mailing list at http://todotxt.com
	            Code repository: http://github.com/ginatrapani/todo.txt-cli/tree/master
                PowerShell port by ",
                'endowdly' -Color Gray, DarkBlue

#   exit 1    # May exit the shell
    break 1   # Kills the calling function
}

# __END__
