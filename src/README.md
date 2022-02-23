# CodeReview.AdHocReview [dotnet-analysis]

## Requirements

- Powershell - https://github.com/PowerShell/powershell/releases
- Docker Engine - https://docs.docker.com/engine/install/

## Command Arguments

| Arguments             | Required | Type   | Description argument               |
|-----------------------|----------|--------|------------------------------------|
| SolutionDirectoryPath | True     | String | Path to the solution folder        |
| SolutionRelativePath  | True     | String | Relative path to the solution file |
| Output                | True     | String | Path to the output directory       |

## Example

- Clone [CodeReview.AdHocReview](https://github.com/GodelTech/CodeReview.AdHocReview)
- Clone [CodeReview.Orchestrator](https://github.com/GodelTech/CodeReview.Orchestrator) (can be any project you want to analyze)
- Navigate to `CodeReview.AdHockCheck\src` folder
- Run `.\dotnet-analysis.ps1 -SolutionDirectoryPath C:\CodeReview.Orchestrator -SolutionRelativePath CodeReview.Orchestrator.sln -Output C:\output`
- All artifacts will be copy to the output folder 