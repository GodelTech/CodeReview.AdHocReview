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

scriptRoot=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Running resharper..."

resharperOutputPath="$outputDirectoryPath/resharper"

sh "$scriptRoot"/resharper/run.sh -SolutionDirectoryPath "$solutionDirectoryPath" -Output "$resharperOutputPath" -SolutionRelativePath "$solutionRelativePath" -NugetConfigFilePath "$nugetConfigFilePath"

echo "Resharper analysis completed."

echo "Running roslyn..."

roslynOutputPath="$outputDirectoryPath/roslyn"

sh "$scriptRoot"/roslyn/run.sh -SolutionDirectoryPath "$solutionDirectoryPath" -Output "$roslynOutputPath" -SolutionRelativePath "$solutionRelativePath" -NugetConfigFilePath "$nugetConfigFilePath"

echo "Roslyn analysis completed."

echo "Running owasp dependency check..."

securityOutputPath="$outputDirectoryPath/security"
sh "$scriptRoot"/security/run.sh -SolutionDirectoryPath "$solutionDirectoryPath" -Output "$securityOutputPath"

echo "Owasp dependency check analysis completed."