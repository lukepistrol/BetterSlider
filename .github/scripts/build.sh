#!/bin/bash

export LC_ALL=en_US.UTF-8

SCHEME="BetterSlider"
DESTINATION="generic/platform=iOS"

set -o pipefail && xcodebuild clean build \
    -scheme $SCHEME \
    -destination $DESTINATION | xcpretty
