# -----------------------------------------------------------------------------
# Todo/Install-Todo
# ------------------------------------------------------------------------------
# ! This installs required directories and files, to inclue a configuration file
#    to allow the posh port of todo.sh to work.
# < void
# > void
# -----------------------------------------------------------------------------
# Pre  -> todo does not exit
# Post -> todo exists
# ----------------------------------------------------------------------------- 

function Install-Todo {
    try {
        Search-TodoConfig
        verbose "Todo config file located at $TODOTXT_CFG_FILE"
    }
    catch {
        warning 'Todo not built, building. . .'

       # => dir test
        $todoDirPresent? = Test-Path $TODO_DIR -PathType Container

        # => file test hash
        $filesTest = @{ 
            $todoFilePath = Test-Path $TODO_FILE -PathType Leaf
            $doneFilePath = Test-Path $DONE_FILE -PathType Leaf
            $reportFilePath = Test-Path $REPORT_FILE -PathType Leaf
        }
        
        # => dir install
        if (-not $todoDirPresent?) {
            warning 'Todo directories do not exist, building. . .'
            try {
                New-Item -Path $TODO_DIR -ItemType Directory > $null
                success 'Todo directory built'
            }
            catch {
                failure 'Todo directory not built; aborting'
                throw
            }
        }#fi

        # => file install
        foreach ($fileTest in $filesTest.GetEnumerator()) {

            if ($fileTest.Value -eq $false) {
                $shortName = Split-Path $fileTest.Key -Leaf
                warning "Todo file $shortName not present; building. . ."

                try {
                    New-Item -Path $fileTest.Key -ItemType File > $null 
                    success "File $shortName built"
                }
                catch {
                    failure "File $shortName not built; aborting"
                    throw
                }
            }#fi
        }#done

        warning 'Installing config file. . .'

        try {
            Install-TodoConfig; success 'Config file installed'
        }
        catch {
            failure 'Config file installation failed; aborting'; throw   
        }
    }#trap
}

# __END__
