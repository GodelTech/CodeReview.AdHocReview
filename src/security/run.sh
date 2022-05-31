#!/bin/bash
solutionDirectoryPath=''
solutionRelativePath=''
outputDirectoryPath=''

while test $# -gt 0; do
  case "$1" in
    -solutionDirectoryPath)
      shift
      solutionDirectoryPath=$1
      shift
      ;;
    -outputDirectoryPath)
      shift
      outputDirectoryPath=$1
      shift
      ;;
    -solutionRelativePath)
      shift
      solutionRelativePath=$1
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

echo "Running analysis for the owasp dependency check workflow..."
importDirectoryPath="$scriptRoot/imports"

sh "$scriptRoot"/../common/run-workflow.sh -workflowFilePath  "$tmpfile" -outputDirectoryPath "$outputDirectoryPath" -importDirectoryPath "$importDirectoryPath" -sourceDirectoryPath "$solutionDirectoryPath"

echo "Removing $tmpfile file"
rm "$tmpfile"