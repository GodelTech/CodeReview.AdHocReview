# CodeReview.AdHocReview

## Analysis

Each analysis locates in the corresponding directory in the `src` folder.
The analysis folder should contains the following
```
|-- src
    `-- cloc <- analysis name
        |   README.md <- contains all information on how to run an analysis
        |   run.ps1   <- script to run an analysis
        |   workflow.yaml <- analysis workflow
        |
        `-- imports <- directory to be imported into the container [TODO: not working :)]
                .gitkeep
```