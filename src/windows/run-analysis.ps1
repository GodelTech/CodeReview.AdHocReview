param(
    [Parameter(Mandatory=$True)]
    [string] $SolutionDirectoryPath,

    [Parameter(Mandatory=$True)]
    [string] $SolutionRelativePath,

    [Parameter(Mandatory=$True)]
    [string] $Output
)

function Get-ObjectMember([PSCustomObject]$obj) {
    $obj | Get-Member -MemberType NoteProperty | ForEach-Object {
        $key = $_.Name
        [PSCustomObject]@{Key = $key; Value = $obj."$key"}
    }
}

function Get-WorkflowYaml([string] $workflow) {
    $workflowsResourcesMapContent = Get-Content -Path .\..\settings\workflows-resources-map.json -Raw
    $workflowsResourcesJson = ConvertFrom-Json -InputObject $workflowsResourcesMapContent

    foreach ($jsonObj in $workflowsResourcesJson) {
        $pair = Get-ObjectMember $jsonObj

        if ($pair.Key -eq $workflow) {
            return $pair.Value
        }
    }
}

function RunOrchestrator([string] $workflow) {
    Write-Host "Running analysis for the $workflow workflow..."
    
    $workflowYaml = Get-WorkflowYaml $workflow
    $workflowFile = New-TemporaryFile

    Write-Host "Temporary workflow file name is $workflowFile"

    Copy-Item -Path .\..\resources\$workflowYaml  -Destination $workflowFile

    Write-Host "Creating docker container godeltech/codereview.orchestrator..."

    docker create --name orchestrator -v /var/run/docker.sock:/var/run/docker.sock godeltech/codereview.orchestrator run -f workflow.yaml
    if (-not $?) {
        Remove-Item $workflowFile

        Write-Error -Message "Failed to create a container for the $workflow workflow"

        return
    }

    $workflowFileContent = Get-Content -Path $workflowFile
    $workflowFileContent = $workflowFileContent.Replace('{SOLUTION_FILE_PATH}', $SolutionRelativePath)
    Set-Content -Path $workflowFile -Value $workflowFileContent

    Write-Host "Copy workflow file to the container..."
    docker cp $workflowFile orchestrator:/app/workflow.yaml

    Write-Host "Copy solution to the container..."
    docker cp $SolutionDirectoryPath orchestrator:/app/imports

    Write-Host "Running container..."
    docker start -a orchestrator

    Write-Host "Exporting results..."
    $outputPath = "$Output\\$workflow"
    docker cp orchestrator:/app/artifacts $outputPath

    Write-Host "Removing container..."
    docker rm orchestrator

    Write-Host "Removing $workflowFile files"
    Remove-Item $workflowFile
}

docker version
IF (-not $?) { exit }

Write-Host "Docker pulling image godeltech/codereview.orchestrator..."

docker image pull godeltech/codereview.orchestrator
IF (-not $?) { exit }

$workflowsContent = Get-Content -Path .\..\settings\workflows.json -Raw
$workflowsJson = ConvertFrom-Json -InputObject $workflowsContent

foreach ($workflow in $workflowsJson) {
    RunOrchestrator $workflow
}