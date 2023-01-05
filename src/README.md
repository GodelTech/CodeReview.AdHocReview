# CodeReview.AdHocReview [dotnet-analysis]

## Requirements

- Powershell - https://github.com/PowerShell/powershell/releases
- Docker Engine - https://docs.docker.com/engine/install/

## Command Arguments

| Arguments             | Required | Type   | Description argument                                                   |
|-----------------------|----------|--------|------------------------------------------------------------------------|
| SolutionDirectoryPath | True     | String | Path to the solution folder                                            |
| SolutionRelativePath  | True     | String | Relative path to the solution file                                     |
| Output                | True     | String | Path to the output directory                                           |
| NugetConfigFilePath   | False    | String | Path to the nuget.config file (can be used in case of private sources) |

## Example

- Clone [CodeReview.AdHocReview](https://github.com/GodelTech/CodeReview.AdHocReview)
- Clone [CodeReview.Orchestrator](https://github.com/GodelTech/CodeReview.Orchestrator) (can be any project you want to analyze)
- If you are using private nuget sources, create nuget.config with source path and credentials. More information can be found on the Microsoft documentation [page](https://learn.microsoft.com/en-us/nuget/reference/nuget-config-file) ([nuget.config example](../documents/nuget.config))
- Navigate to `CodeReview.AdHockCheck\src` folder
- [Windows] Run `.\dotnet-analysis.ps1 -SolutionDirectoryPath C:\CodeReview.Orchestrator -SolutionRelativePath CodeReview.Orchestrator.sln -Output C:\output`
- [Linux] Run `.\run.sh -SolutionDirectoryPath /CodeReview.Orchestrator -SolutionRelativePath CodeReview.Orchestrator.sln -Output /output`
- All artifacts will be copy to the output folder 