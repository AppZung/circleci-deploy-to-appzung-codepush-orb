#!/bin/bash
set -ex

# Parse parameters with variable substitution
API_KEY=$(circleci env subst "${PARAM_API_KEY}")
RELEASE_CHANNEL=$(circleci env subst "${PARAM_RELEASE_CHANNEL}")
MANDATORY=$(circleci env subst "${PARAM_MANDATORY}")
DISABLED=$(circleci env subst "${PARAM_DISABLED}")
ROLLOUT=$(circleci env subst "${PARAM_ROLLOUT}")
TARGET_BINARY_VERSION=$(circleci env subst "${PARAM_TARGET_BINARY_VERSION}")
PRIVATE_KEY_PATH=$(circleci env subst "${PARAM_PRIVATE_KEY_PATH}")
DESCRIPTION_FROM_GIT=$(circleci env subst "${PARAM_DESCRIPTION_FROM_GIT}")
EXTRA_FLAGS=$(circleci env subst "${PARAM_EXTRA_FLAGS}")

# Validate required parameters
if [ -z "$RELEASE_CHANNEL" ]; then
    echo "Error: release_channel parameter is required"
    exit 1
fi

if [ -z "$API_KEY" ]; then
    echo "Error: api_key parameter is required"
    exit 1
fi

# Install AppZung CLI if not already installed
if which appzung > /dev/null; then
  echo "AppZung CLI already installed."
else
  echo "Installing AppZung CLI..."
  npm install -g @appzung/cli@1
fi

# Build the base command
DEPLOY_CMD="appzung releases deploy-react-native --release-channel \"$RELEASE_CHANNEL\" --api-key \"$API_KEY\""

if [ "$MANDATORY" == "true" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --mandatory"
fi

if [ "$DISABLED" == "true" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --disabled"
fi

if [ -n "$ROLLOUT" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --rollout $ROLLOUT"
fi

if [ -n "$TARGET_BINARY_VERSION" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --target-binary-version \"$TARGET_BINARY_VERSION\""
fi

if [ -n "$PRIVATE_KEY_PATH" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --private-key-path \"$PRIVATE_KEY_PATH\""
fi

if [ "$DESCRIPTION_FROM_GIT" == "true" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --description-from-current-git-commit"
fi

if [ -n "$EXTRA_FLAGS" ]; then
    DEPLOY_CMD="$DEPLOY_CMD $EXTRA_FLAGS"
fi

echo "Executing deploy React Native command..."
echo "$DEPLOY_CMD"

eval "$DEPLOY_CMD"
