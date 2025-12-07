#!/bin/bash

# Build script for notion_agent Docker image

set -e

IMAGE_NAME="notion_agent"
IMAGE_TAG="${1:-latest}"

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"

docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

echo ""
echo "Build complete!"
echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo ""
echo "To run the container:"
echo "  docker run -it --rm \\"
echo "    -e ANTHROPIC_API_KEY=your_key \\"
echo "    -e NOTION_API_KEY=your_notion_key \\"
echo "    ${IMAGE_NAME}:${IMAGE_TAG}"
