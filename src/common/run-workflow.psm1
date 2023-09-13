function Start-Orchestrator {
param (
    [Parameter(Mandatory=$True)]
    [string] $workflowFilePath,

    [Parameter(Mandatory=$True)]
    [string] $outputDirectoryPath,

    [Parameter(Mandatory=$True)]
    [string] $importDirectoryPath,

    [Parameter(Mandatory=$True)]
    [string] $sourceDirectoryPath,

    [Parameter(Mandatory=$False)]
    [string] $nugetConfigFilePath = $null
)
    $containerId = docker ps --filter "name=orchestrator"  -a -q

    if ($containerId -ne $null)
    {
        Write-Host "Killing existing docker container godeltech/codereview.orchestrator..."
        docker container rm $containerId
    }

    Write-Host "Creating docker container godeltech/codereview.orchestrator..."
    docker create --name orchestrator -v /var/run/docker.sock:/var/run/docker.sock godeltech/codereview.orchestrator run -f workflow.yaml -b LoadLatest
    if (-not $?) {
        Write-Error -Message "Failed to create a container for the $workflow workflow"
    
        return $False
    }

    if ((CopyToContainer $workflowFilePath '/app/workflow.yaml') -eq $False) {
        return $False
    }

    if ((CopyToContainer $sourceDirectoryPath '/app/src') -eq $False) {
        return $False
    }

    if ((CopyToContainer $importDirectoryPath '/app/imports') -eq $False) {
        return $False
    }

    if ([string]::IsNullOrEmpty($nugetConfigFilePath) -eq $False -And 
        (CopyToContainer $nugetConfigFilePath '/app/src') -eq $False) {
        return $False
    }

    Write-Host "Running container..."
    docker start -a orchestrator

    Write-Host "Exporting artifacts..."
    docker cp orchestrator:/app/artifacts $outputDirectoryPath

    Write-Host "Exporting reports..."
    docker cp orchestrator:/app/reports $outputDirectoryPath

    Write-Host "Removing container..."
    docker rm orchestrator

    return $True
}

function CopyToContainer {
param (
    [Parameter(Mandatory=$True)]
    [string] $directoryPath,

    [Parameter(Mandatory=$True)]
    [string] $targetPath
)
    Write-Host "Copy $directoryPath to the container..."

    docker cp $directoryPath orchestrator:$targetPath

    if (-not $?) {
        Write-Error -Message "Cannot copy $directoryPath to the container"

        docker rm orchestrator

        return $False
    }

    return $True
}
