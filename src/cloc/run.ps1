param(
    [Parameter(Mandatory=$True)]
    [string] $SolutionDirectoryPath,

    [Parameter(Mandatory=$True)]
    [string] $OutputDirectoryPath
)

Import-Module "$PSScriptRoot\..\common\run-workflow.psm1" -Force

docker version
IF (-not $?) { exit }

Write-Host "Docker pulling image godeltech/codereview.orchestrator..."

docker image pull godeltech/codereview.orchestrator
IF (-not $?) { exit }

$tmpFile = New-TemporaryFile

Write-Host "Running analysis for the $workflow workflow..."

Copy-Item -Path $PSScriptRoot\workflow.yaml  -Destination $tmpFile

Start-Orchestrator -workflowFilePath $tmpFile -outputDirectoryPath $OutputDirectoryPath -importDirectoryPath $SolutionDirectoryPath

Write-Host "Removing $tmpFile file"
Remove-Item $tmpFile