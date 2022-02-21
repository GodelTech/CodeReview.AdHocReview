#!/bin/bash
solutionDirectoryPath=''
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

cp "$scriptRoot/workflow.yaml" "$tmpfile"

echo "Running analysis for the cloc workflow..."

sh "$scriptRoot"/../common/run-workflow.sh -workflowFilePath  "$tmpfile" -outputDirectoryPath "$outputDirectoryPath" -importDirectoryPath "$solutionDirectoryPath"

echo "Removing $tmpfile file"
rm "$tmpfile"