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

Write-Host "Running analysis for the owasp dependency check workflow..."

Copy-Item -Path $PSScriptRoot\workflow.yaml -Destination $tmpFile

$importDirectoryPath = "$PSScriptRoot\imports"

Start-Orchestrator -workflowFilePath $tmpFile -outputDirectoryPath $OutputDirectoryPath -importDirectoryPath $importDirectoryPath -sourceDirectoryPath $SolutionDirectoryPath

Write-Host "Removing $tmpFile file"
Remove-Item $tmpFile