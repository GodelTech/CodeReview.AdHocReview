function Start-Orchestrator {
param (
    [Parameter(Mandatory)][string] $workflowFilePath,
    [Parameter(Mandatory)][string] $outputDirectoryPath,
    [Parameter(Mandatory)][string] $importDirectoryPath,
    [Parameter(Mandatory)][string] $sourceDirectoryPath
)
    Write-Host "Creating docker container godeltech/codereview.orchestrator..."
    
    docker create --name orchestrator -v /var/run/docker.sock:/var/run/docker.sock godeltech/codereview.orchestrator run -f workflow.yaml -b LoadLatest
    if (-not $?) {
        Write-Error -Message "Failed to create a container for the $workflow workflow"
    
        return $False
    }
    
    Write-Host "Copy workflow file to the container..."
    docker cp $workflowFilePath orchestrator:/app/workflow.yaml
    if (-not $?) {
        Write-Error -Message "Cannot copy workflow file to the container"
    
        docker rm orchestrator
    
        return $False
    }

    Write-Host "Copy source directory to the container..."
    docker cp $sourceDirectoryPath orchestrator:/app/src
    if (-not $?) {
        Write-Error -Message "Cannot copy source directory to the container"

        docker rm orchestrator

        return $False
    }

    Write-Host "Copy import directory to the container..."
    docker cp $importDirectoryPath orchestrator:/app/imports
    if (-not $?) {
        Write-Error -Message "Cannot copy import directory to the container"
    
        docker rm orchestrator
    
        return $False
    }

    Write-Host "Copy nuget directory to the container..."
    docker cp 'C:\Work\intelliflo\packages' orchestrator:/app/nuget
    if (-not $?) {
        Write-Error -Message "Cannot copy nuget directory to the container"
    
        docker rm orchestrator
    
        return $False
    }

    Write-Host "Running container..."
    docker start -a orchestrator

    Write-Host "Exporting artifacts..."
    docker cp orchestrator:/app/artifacts $outputDirectoryPath

    Write-Host "Removing container..."
    docker rm orchestrator

    return $True
}

