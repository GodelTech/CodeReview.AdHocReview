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

Write-Host "Running resharper..."

$resharperOutputPath = "$OutputDirectoryPath\resharper"
if ([string]::IsNullOrEmpty($NugetConfigFilePath)) {
    powershell "$PSScriptRoot\resharper\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $resharperOutputPath -SolutionRelativePath $SolutionRelativePath"
}
else {
    powershell "$PSScriptRoot\resharper\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $resharperOutputPath -SolutionRelativePath $SolutionRelativePath -NugetConfigFilePath $NugetConfigFilePath"
}

Write-Host "Resharper analysis completed."

Write-Host "Running roslyn..."

$roslynOutputPath = "$OutputDirectoryPath\roslyn"
if ([string]::IsNullOrEmpty($NugetConfigFilePath)) {
    powershell "$PSScriptRoot\roslyn\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $roslynOutputPath -SolutionRelativePath $SolutionRelativePath"
}
else {
    powershell "$PSScriptRoot\roslyn\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $roslynOutputPath -SolutionRelativePath $SolutionRelativePath -NugetConfigFilePath $NugetConfigFilePath"
}

Write-Host "Roslyn analysis completed."

Write-Host "Running owasp dependency check..."

$securityOutputPath = "$OutputDirectoryPath\security"
powershell "$PSScriptRoot\security\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $securityOutputPath"

Write-Host "Owasp dependency check analysis completed."