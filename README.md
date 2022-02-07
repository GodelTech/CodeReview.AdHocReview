# CodeReview.AdHocReview

## Requirements

- Powershell - https://github.com/PowerShell/powershell/releases
- Docker Engine - https://docs.docker.com/engine/install/ 

## Workflows

Currently supported 3 workflows: 
- Cloc `cloc-workflow.yaml`
- Resharper `resharper-workflow.yaml`
- Roslyn `roslyn-workflow.yaml`

To exclude workflows from the analysis, simply remove the unnecessary workflow from the `CodeReview.AdHockCheck\src\settings\workflows.json` file.

To add new workflow, follow these steps:
- Add a new workflow to the `CodeReview.AdHockCheck\src\resources` directory
- Add mapping `workflow name - workflow file` to the `CodeReview.AdHockCheck\src\settings\workflows-resources-map.json`
```
[
  { "cloc": "cloc-workflow.yaml" },
  { "roslyn": "roslyn-workflow.yaml" },
  { "resharper": "resharper-workflow.yaml" },
  { "myWorkflow": "my-workflow.yaml" } <-- the new workflow
]
```
- Add a new workflow name to the `CodeReview.AdHockCheck\src\settings\workflows.json` file
```
[
  "cloc",
  "roslyn",
  "resharper",
  "myWorkflow" <-- the new workflow
]
```


## Command Arguments

| Arguments             | Required | Type   | Description argument               |
|-----------------------|----------|--------|------------------------------------|
| SolutionDirectoryPath | True     | String | Path to the solution folder        |
| SolutionRelativePath  | True     | String | Relative path to the solution file |
| Output                | True     | String | Path to the output directory       |

## Example

- Clone [CodeReview.AdHocReview](https://github.com/GodelTech/CodeReview.AdHocReview)
- Clone [CodeReview.Orchestrator](https://github.com/GodelTech/CodeReview.Orchestrator) (can be any project you want to analyze)
- Navigate to `CodeReview.AdHockCheck\src\windows\` folder
- Run `.\run-analysis.ps1 -SolutionDirectoryPath C:\CodeReview.Orchestrator -SolutionRelativePath CodeReview.Orchestrator.sln -Output C:\output`
- All artifacts will be copy to the output folder 