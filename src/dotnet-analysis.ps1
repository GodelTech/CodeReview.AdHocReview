param(
    [Parameter(Mandatory=$True)]
    [string] $SolutionDirectoryPath,

    [Parameter(Mandatory=$True)]
    [string] $OutputDirectoryPath,

    [Parameter(Mandatory=$True)]
    [string] $SolutionRelativePath
)

Write-Host "Running cloc..."

$clocOutputPath = "$OutputDirectoryPath\cloc"
powershell "$PSScriptRoot\cloc\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $clocOutputPath"

Write-Host "Cloc analysis completed."

Write-Host "Running resharper..."

$clocOutputPath = "$OutputDirectoryPath\resharper"
powershell "$PSScriptRoot\resharper\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $clocOutputPath -SolutionRelativePath $SolutionRelativePath"

Write-Host "Resharper analysis completed."

Write-Host "Running roslyn..."

$clocOutputPath = "$OutputDirectoryPath\roslyn"
powershell "$PSScriptRoot\roslyn\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $clocOutputPath -SolutionRelativePath $SolutionRelativePath"

Write-Host "Roslyn analysis completed."