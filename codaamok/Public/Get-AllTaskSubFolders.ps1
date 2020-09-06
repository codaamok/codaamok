function Get-AllTaskSubFolders {
                [cmdletbinding()]
                param (
                    # Set to use $Schedule as default parameter so it automatically list all files
                    # For current schedule object if it exists.
                    $FolderRef = $sch.getfolder("\"),

                    [switch]$recurse
                )

                #No recurse?  Return the folder reference
                if (-not $recurse) {
                    $FolderRef
                }
                #Recurse?  Build up an array!
                else {
                    Try{
                        #This will fail on older systems...
                        $folders = $folderRef.getfolders(1)

                        #Extract results into array
                        $ArrFolders = @(
                            if($folders) {
                                foreach ($fold in $folders) {
                                    $fold
                                    if($fold.getfolders(1)) {
                                        Get-AllTaskSubFolders -FolderRef $fold
                                    }
                                }
                            }
                        )
                    }
                    Catch{
                        #If we failed and the expected error, return folder ref only!
                        if($_.tostring() -like '*Exception calling "GetFolders" with "1" argument(s): "The request is not supported.*')
                        {
                            $folders = $null
                            Write-Warning "GetFolders failed, returning root folder only: $_"
                            Return $FolderRef
                        }
                        else{
                            Throw $_
                        }
                    }

                    #Return only unique results
                        $Results = @($ArrFolders) + @($FolderRef)
                        $UniquePaths = $Results | select -ExpandProperty path -Unique
                        $Results | ?{$UniquePaths -contains $_.path}
                }
            }
