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

$resharperOutputPath = "$OutputDirectoryPath\resharper"
powershell "$PSScriptRoot\resharper\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $resharperOutputPath -SolutionRelativePath $SolutionRelativePath"

Write-Host "Resharper analysis completed."

Write-Host "Running roslyn..."

$roslynOutputPath = "$OutputDirectoryPath\roslyn"
powershell "$PSScriptRoot\roslyn\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $roslynOutputPath -SolutionRelativePath $SolutionRelativePath"

Write-Host "Roslyn analysis completed."

Write-Host "Running owasp dependency check..."

$securityOutputPath = "$OutputDirectoryPath\security"
powershell "$PSScriptRoot\security\run.ps1 -SolutionDirectoryPath $SolutionDirectoryPath -OutputDirectoryPath $securityOutputPath"

Write-Host "Owasp dependency check analysis completed."