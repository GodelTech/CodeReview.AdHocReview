#!/bin/bash
solutionDirectoryPath=''
solutionRelativePath=''
outputDirectoryPath=''
nugetConfigFilePath=''

while test $# -gt 0; do
  case "$1" in
    -SolutionDirectoryPath)
      shift
      solutionDirectoryPath=$1
      shift
      ;;
    -Output)
      shift
      outputDirectoryPath=$1
      shift
      ;;
    -SolutionRelativePath)
      shift
      solutionRelativePath=$1
      shift
      ;;
    -NugetConfigFilePath)
      shift
      nugetConfigFilePath=$1
      shift
      ;;
  *)
      break
      ;;
  esac
done

if ! docker version; then
  exit
fi

echo "Docker pulling image godeltech/codereview.orchestrator..."

if ! docker image pull godeltech/codereview.orchestrator; then
  exit
fi

tmpfile=$(mktemp)
scriptRoot=$(dirname "$0")

awk "{sub(\"{SOLUTION_FILE_PATH}\",\"$solutionRelativePath\")}1" "$scriptRoot/workflow.yaml" > "$tmpfile"
importDirectoryPath="$scriptRoot/imports"

echo "Running analysis for the resharper workflow..."

sh "$scriptRoot"/../common/run-workflow.sh -workflowFilePath  "$tmpfile" -outputDirectoryPath "$outputDirectoryPath" -importDirectoryPath "$importDirectoryPath" -sourceDirectoryPath "$solutionDirectoryPath" -nugetConfigFilePath "$nugetConfigFilePath"

echo "Removing $tmpfile file"
rm "$tmpfile"