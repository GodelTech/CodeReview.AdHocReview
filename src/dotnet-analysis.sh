#!/bin/bash
solutionDirectoryPath=''
solutionRelativePath=''
outputDirectoryPath=''
nugetConfigFilePath = ''

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
    -nugetConfigFilePath)
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
echo "Running cloc..."

clocOutputPath="$outputDirectoryPath/cloc"
sh "$scriptRoot"/cloc/run.sh -solutionDirectoryPath "$solutionDirectoryPath" -outputDirectoryPath "$clocOutputPath"

echo "Cloc analysis completed."

echo "Running resharper..."

resharperOutputPath="$outputDirectoryPath/resharper"
sh "$scriptRoot"/resharper/run.sh -solutionDirectoryPath "$solutionDirectoryPath" -outputDirectoryPath "$resharperOutputPath" -solutionRelativePath "$solutionRelativePath" -nugetConfigFilePath "$nugetConfigFilePath"

echo "Resharper analysis completed."

echo "Running roslyn..."

roslynOutputPath="outputDirectoryPath/roslyn"
sh "$scriptRoot"/roslyn/run.sh -solutionDirectoryPath "$solutionDirectoryPath" -outputDirectoryPath "$roslynOutputPath" -solutionRelativePath "$solutionRelativePath" -nugetConfigFilePath "$nugetConfigFilePath"

echo "Roslyn analysis completed."

echo "Running owasp dependency check..."

securityOutputPath="outputDirectoryPath/security"
sh "$scriptRoot"/security/run.sh -solutionDirectoryPath "$solutionDirectoryPath" -outputDirectoryPath "$securityOutputPath"

echo "Owasp dependency check analysis completed."