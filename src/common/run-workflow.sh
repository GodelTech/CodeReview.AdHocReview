workflowFilePath=''
outputDirectoryPath=''
importDirectoryPath=''
sourceDirectoryPath=''
nugetConfigFilePath=''

while test $# -gt 0; do
  case "$1" in
  -workflowFilePath)
    shift
    workflowFilePath=$1
    shift
    ;;
  -outputDirectoryPath)
    shift
    outputDirectoryPath=$1
    shift
    ;;
  -importDirectoryPath)
    shift
    importDirectoryPath=$1
    shift
    ;;
  -sourceDirectoryPath)
    shift
    sourceDirectoryPath=$1
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

echo "Creating docker container godeltech/codereview.orchestrator..."

if ! docker create --name orchestrator -v /var/run/docker.sock:/var/run/docker.sock godeltech/codereview.orchestrator run -f workflow.yaml; then
  echo "Failed to create a container for the $workflow workflow"

  exit 1
fi

echo "Copy $workflowFilePath to the container..."
if ! docker cp "$workflowFilePath" orchestrator:/app/workflow.yaml; then
  echo "Cannot copy $workflowFilePath to the container"
  docker rm orchestrator

  exit 1
fi

echo "Copy $sourceDirectoryPath to the container..."
if ! docker cp "$sourceDirectoryPath" orchestrator:/app/src; then
  echo "Cannot $sourceDirectoryPath to the container"
  docker rm orchestrator

  exit 1
fi

echo "Copy $importDirectoryPath to the container..."
if ! docker cp "$importDirectoryPath" orchestrator:/app/imports; then
  echo "Cannot copy $importDirectoryPath to the container"
  docker rm orchestrator

  exit 1
fi

if [ ! -z "$nugetConfigFilePath" ]; then
  echo "Copy $nugetConfigFilePath to the container..."

  if ! docker cp "$nugetConfigFilePath" orchestrator:/app/src; then
    echo "Cannot copy $nugetConfigFilePath to the container"
    docker rm orchestrator

    exit 1
  fi
fi

echo "Running container..."
docker start -a orchestrator

echo "Exporting artifacts..."
docker cp orchestrator:/app/artifacts "$outputDirectoryPath"

echo "Exporting reports..."
docker cp orchestrator:/app/reports "$outputDirectoryPath"

echo "Removing container..."
docker rm orchestrator

exit 0