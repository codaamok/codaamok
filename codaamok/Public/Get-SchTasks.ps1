function Get-SchTasks {
            [cmdletbinding()]
            param([string]$computername, [string]$folder, [switch]$CompatibilityMode)
            
            #we format the properties to match those returned from com objects
            $result = @( schtasks.exe /query /v /s $computername /fo csv |
                convertfrom-csv |
                ?{$_.taskname -ne "taskname" -and $_.taskname -match $( $folder.replace("\","\\") ) } |
                select @{ label = "ComputerName"; expression = { $computername } },
                    @{ label = "Name"; expression = { $_.TaskName } },
                    @{ label = "Action"; expression = {$_."Task To Run"} },
                    @{ label = "LastRunTime"; expression = {$_."Last Run Time"} },
                    @{ label = "NextRunTime"; expression = {$_."Next Run Time"} },
                    "Status",
                    "Author"
            )

            if($CompatibilityMode){
                #User requested compat mode, don't add props
                $result    
            }
            else{
                #If this was a failback, we don't want to affect display of props for comps that don't fail... include empty props expected for com object
                #We also extract task name and path to parent for the Name and Path props, respectively
                foreach($item in $result){
                    $name = @( $item.Name -split "\\" )[-1]
                    $taskPath = $item.name
                    $item | select ComputerName, @{ label = "Name"; expression = {$name}}, @{ label = "Path"; Expression = {$taskPath}}, Enabled, Action, Arguments, UserId, LastRunTime, NextRunTime, Status, Author, RunLevel, Description, NumberOfMissedRuns
                }
            }
        }
