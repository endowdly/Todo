#! /usr/bin/env PowerShell

# NOTE: Todo.ps1 requires the .todo/config configuration file to run.
#  Place the .todo/config file in your home directory or use the -d option for
#  a custom location

function Invoke-Todo {
    <#
    .Notes
      TODO.TXT Command Line Interface. Call -Version for current Version.

      First release: 5/11/2006
      First release: 5/11/2006
      Original conception by: Gina Trapani (http://ginatrapani.org)
      PowerShell port by: endowdly

    .Link
      http://github.com/ginatrapani/todo.txt-cli/network
      http://www.gnu.org/copyleft/gpl.html
      http://todotxt.com
      http://github.com/ginatrapani/todo.txt-cli/tree/master
    #>

    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType([String])]

    param (

        # --- Actions First ---
        [Parameter(ParameterSetName='Add')]
        [Alias('a')]
        [Switch] $Add,

        [Parameter(ParameterSetName='AddTo')]
        [Switch] $AddTo,

        [Parameter(ParameterSetName='Append')]
        [Switch] $Append,

        [Parameter(ParameterSetName='Archive')]
        [Switch] $Archive,

        [Parameter(ParameterSetName='RemoveDuplicates')]
        [Alias('Deduplicate')]
        [Switch] $RemoveDuplicates,

        [Parameter(ParameterSetName='Remove')]
        [Alias('del', 'rm', 'delete')]
        [Switch] $Remove,

        [Parameter(ParameterSetName='RemovePriority')]
        [Alias('depri','dp')]
        [Switch] $RemovePriority,

        [Parameter(ParameterSetName='Do')]
        [Alias('Complete')]
        [Switch] $Do,

        [Parameter(ParameterSetName='List')]
        [Alias('ls')]
        [Switch] $List,

        [Parameter(ParameterSetName='ListAll')]
        [Alias('lsa')]
        [Switch] $ListAll,

        [Parameter()]
        [Switch] $ListAllAddOns,

        [Parameter(ParameterSetName='ListContext')]
        [Alias('lsc')]
        [Switch] $ListContext,

        [Parameter(ParameterSetName='ListFile')]
        [Alias('lf')]
        [Switch] $ListFile,

        [Parameter(ParameterSetName='ListPriority')]
        [Alias('lsp')]
        [Switch] $ListPriority,

        [Parameter(ParameterSetName='ListProject')]
        [Alias('lsprj')]
        [Switch] $ListProject,

        [Parameter(ParameterSetName='Move')]
        [Alias('mv')]
        [Switch] $Move,

        [Parameter(ParameterSetName='Prepend')]
        [Switch] $Prepend,

        [Parameter(ParameterSetName='Prioritize')]
        [Switch] $Prioritize,

        [Parameter(ParameterSetName='Replace')]
        [Switch] $Replace,

        [Parameter()]
        [Switch] $Report,

        [Parameter(ParameterSetName='Usage')]
        [Alias('Help')]
        [Switch] $ShortHelp,

        # --- Action Arguments ---
        [Parameter(ParameterSetName='Add',
                   Position=0,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Mandatory=$true,
                   HelpMessage='Enter text to add')]
        [Parameter(ParameterSetName='AddTo',
                   Position=0,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Mandatory=$true,
                   HelpMessage='Enter text to add to destination')]
        [Parameter(ParameterSetName='Append',
                   Position=1,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Text to append to the end of task')]
        [Parameter(ParameterSetName='Prepend',
                   Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage='Text to add to the beginning of task')]
        [Parameter(ParameterSetName='Replace',
                   Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage='Text to replace text at item')]
        [String] $Text,

        [Parameter(Position=2,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetName='Add')]
        [Parameter(Position=3,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetname='AddTo')]
        [String] $Project,

        [Parameter(Position=3,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetName='Add')]
        [Parameter(Position=4,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetname='AddTo')]
        [String] $Context,

        [Parameter()]
        [ValidateScript({ Test-Path $_ -PathType Leaf})]
        [Alias('src','Source')]
        [String] $Path=$TODO_FILE,

        [Parameter(ParameterSetName='Append', 
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Enter item number to add text to')]
        [Parameter(ParameterSetName='Remove',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Enter an item to delete')]
        [Parameter(ParameterSetName='RemovePriority',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Enter item or item array to remove priority')]
        [Parameter(ParameterSetName='Do',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Enter tasks to complete')]
        [Parameter(ParameterSetName='Move',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Enter line to move to destination')]
        [Parameter(ParameterSetName='Prepend',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Item to add text to')]
        [Parameter(ParameterSetName='Prioritize',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Add Priority to task on line item')]
        [Parameter(ParameterSetName='Replace',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Item to replace')]
        [Int] $Item,

        [Parameter(ParameterSetName='Add',
                   Position=4,
                   ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='AddTo',
                   Position=5,
                   ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Prioritize',
                   Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage='Priority must be a letter from A-Z')]
        [Parameter(ParameterSetName='ListPriority',
                   Position=0,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$true,
                   HelpMessage='Priority must be a letter from A-Z')]
        [ValidatePattern('[a-zA-Z]')]
        [Char] $Priority,

        [Parameter(ParameterSetName='Remove',
                   Position=1,
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='List',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ListAll',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ListContext',
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ListFile',
                   Position=1,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='ListPriority',
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [Parameter(ParameterSetName='ListProject',
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [String] $Term,

        [Parameter(ParameterSetName='AddTo',
                   Position=1,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Enter a destination file')]
        [Parameter(ParameterSetName='Move',
                   Position=1,
                   ValueFromPipelineByPropertyName=$true,
                   Mandatory=$true,
                   HelpMessage='Enter a destination file')]
        #[ValidateScript({ Test-Path $_ -PathType Leaf})]
        [Alias('Dest')]
        [String] $Destination,

        [String] $Command,

        # --- Options ---
        [Alias('@')]
        [Switch] $HideContextNames,

        [Alias('+')]
        [Switch] $HideProjectNames,

        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [Alias('d')]
        [String] $ConfigFile=$TODOTXT_CFG_FILE,

        [Switch] $Force,

        [Alias('p')]
        [Switch] $Plain,

        [Switch] $HidePriorityLabels,

        [Switch] $AutoArchive,

        [Alias('n')]
        [Switch] $PreserveLineNumbers,

        [Alias('t')]
        [Switch] $DateOnAdd,

        [Alias('vv')]
        [Switch] $VerboseSwitch,
        
        [Switch] $Version,

        [Alias('x')]
        [Switch] $DisableFilter,

        [Switch] $ShowOptions
    )# __param

    begin {
        # -> Read ConfigFile
        $script:TODOTXT_CFG_FILE = $ConfigFile   # defaults to itself
        Read-TodoConfig
        # -> Process Options 
        if ($AutoArchive) { $script:TODOTXT_AUTO_ARCHIVE = -not $TODOTXT_AUTO_ARCHIVE }
        if ($Plain) { $script:TODOTXT_PLAIN = -not $TODOTXT_PLAIN } 
        if ($Force) { $script:TODOTXT_FORCE = -not $TODOTXT_FORCE }
        if ($PreserveLineNumbers) { $script:TODOTXT_PRESERVE_LINE_NUMBERS = -not $TODOTXT_PRESERVE_LINE_NUMBERS }
        if ($DateOnAdd) { $script:TODOTXT_DATE_ON_ADD = -not $TODOTXT_DATE_ON_ADD } 
        if ($VerboseSwitch) { $script:TODOTXT_VERBOSE = -not $TODOTXT_VERBOSE }
        if ($DisableFilter) { $script:TODOTXT_DISABLE_FILTER = -not $TODOTXT_DISABLE_FILTER } 
        if ($HideContextNames) { $HideContextExpression = '\s[@][\P{Z}\P{C}]+'}
        if ($HideProjectNames) { $HideProjectExpression = '\s[+][\P{Z}\P{C}]+' }
        if ($HidePriorityLables) { $HidePriorityExpression = '\([A-Z]\)\s' } 
        if ($ListAddOns) { 'big mystery'; }
        if ($Version) { Write-TodoVersion }
        if ($ShortHelp) { Write-TodoUsage }
        if ($Report) { Update-Report }
        if ($Command) { Start-AddOnCommand } 
        if ($ShowOptions) { Show-TodoOptions; break } 
        # => Priority to uppercase
        if ($Priority) { $Priority = $Priority.ToString().ToUpper() } 
    }# __begin

    end { <# empty #> }

    process {
        if ($Item) { $Todo = Get-Todo }
        if ($Item -and -not $Todo) { return }
        switch ($PSCmdlet.ParameterSetName) {
            'Add' { Add-Todo $Path }
            'AddTo' { Add-Todo $Destination }
            'Append' { Update-Todo Append }
            'Archive' { Move-Done }
            'RemoveDuplicates' { Remove-Duplicates }
            'Remove' { Remove-Todo } 
            'Deprioritize' { Remove-TodoPriority }
            'Do' { Complete-Todo }
            'List' { Out-Todo }
            'ListAll' { Out-AllFiles }
            'ListContext' { Out-SigilWords '@' }
            # I don't see a purpose for ListFile, so it hasn't been included
            'ListPriority' { Out-TodoPriorities }
            'ListProject' { Out-SigilWords '+' }
            'Move' { Move-Todo }
            'Prepend' { Update-Todo Prepend }
            'Prioritize' { Update-TodoPriority }
            'Replace' { Reset-Todo }
            default { Write-TodoUsage }
        }# esac
    }
}# __func

# __END__
