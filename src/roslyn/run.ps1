param(
    [Parameter(Mandatory=$True)]
    [string] $SolutionDirectoryPath,

    [Parameter(Mandatory=$True)]
    [string] $SolutionRelativePath,

    [Parameter(Mandatory=$True)]
    [string] $OutputDirectoryPath,

    [Parameter(Mandatory=$False)]
    [string] $NugetConfigFilePath = $null
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

$tmpFileContent = Get-Content -Path $tmpFile
$tmpFileContent = $tmpFileContent.Replace('{SOLUTION_FILE_PATH}', $SolutionRelativePath)
Set-Content -Path $tmpFile -Value $tmpFileContent

$importDirectoryPath = "$PSScriptRoot\imports"

Start-Orchestrator `
    -workflowFilePath $tmpFile `
    -outputDirectoryPath $OutputDirectoryPath `
    -importDirectoryPath $importDirectoryPath `
    -sourceDirectoryPath $SolutionDirectoryPath `
    -nugetConfigFilePath $NugetConfigFilePath

Write-Host "Removing $tmpFile file"
Remove-Item $tmpFile