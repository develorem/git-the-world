$gitAction = $args[0]
$location = $args[1]

$debug = "False"; # "False" or "True"

function Debug($output) {
    if ($debug -eq "True")
    {
        Write-Host $output
    }
}

function PerformGitAction($folder, $action) {
    Push-Location -Path $folder
    Write-Host 
    Write-Host -ForegroundColor Cyan Performing git $action at $folder
    
    $gitcommand = 'git.exe ' + $action
    iex $gitcommand

    if ($LastExitCode -eq 0) { 
        Write-Host -ForegroundColor Green Completed successfully
    }
    else {
        Write-Host -ForegroundColor Red Completed with errors
    }
    Pop-Location
}

function IsGitRepo ($folder) {
    $countOfGitFolders = Get-ChildItem $folder -Force | ?{ $_.PSIsContainer } | ?{$_.Name -eq '.git'} | measure
    $result = $countOfGitFolders.Count -gt 0
    $result
}

function RecursiveProcess {
    param ([string]$folder, [string]$action)

    Debug "RecursiveProcess $folder"

    $gitFolders = Get-ChildItem "$folder" -Force | ?{ $_.PSIsContainer } | ?{ IsGitRepo($_.FullName) }
    $otherFolders = Get-ChildItem "$folder" -Force | ?{ $_.PSIsContainer } | ?{ -Not(IsGitRepo($_.FullName)) }
    
    if ($gitFolders.Count -gt 0) {
        Debug "There are git folders " + $gitFolders.Count
        foreach ($repo in $gitFolders)
        {
            Debug "Repo $repo.FullName"
            PerformGitAction $repo.FullName $action
        }
    }

    if ($otherFolders.Count -gt 0) {
        Debug "There are otherFolders " + $otherFolders.Count
        foreach ($childFolder in $otherFolders)
        {
            Debug "childFolder $childFolder.FullName"
            ProcessIt $childFolder.FullName $action
        }
    }
}

RecursiveProcess -folder $location -action $gitAction
