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

scriptRoot=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Running cloc..."

clocOutputPath="$outputDirectoryPath/cloc"
sh "$scriptRoot"/cloc/run.sh -solutionDirectoryPath "$solutionDirectoryPath" -outputDirectoryPath "$clocOutputPath"

echo "Cloc analysis completed."

echo "Running resharper..."

resharperOutputPath="$outputDirectoryPath/resharper"
sh "$scriptRoot"/resharper/run.sh -solutionDirectoryPath "$solutionDirectoryPath" -outputDirectoryPath "$resharperOutputPath" -solutionRelativePath "$solutionRelativePath"

echo "Resharper analysis completed."

echo "Running roslyn..."

roslynOutputPath="outputDirectoryPath/roslyn"
sh "$scriptRoot"/roslyn/run.sh -solutionDirectoryPath "$solutionDirectoryPath" -outputDirectoryPath "$roslynOutputPath" -solutionRelativePath "$solutionRelativePath"

echo "Roslyn analysis completed."