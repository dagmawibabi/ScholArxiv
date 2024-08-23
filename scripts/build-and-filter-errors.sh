#!/bin/bash

# Run Flutter build command and capture output
flutter build apk --release 2>&1 | tee build_output.log | grep -i "gradle" || true

# Exit with the same code as Flutter build command
exit ${PIPESTATUS[0]}
