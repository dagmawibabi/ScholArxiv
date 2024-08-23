#!/bin/bash

# Define log file
LOG_FILE="build_output.log"

# Run Flutter build command with stack trace and capture output
flutter build apk --release --verbose 2>&1 | tee $LOG_FILE

# Exit with the same code as the Flutter build command
EXIT_CODE=${PIPESTATUS[0]}

# Upload the log file to Telegram
if [ -f $LOG_FILE ]; then
  curl -s -X POST "https://api.telegram.org/bot${{ secrets.STAGING_TELEGRAM_BOT_TOKEN }}/sendDocument" \
    -F chat_id=${{ secrets.STAGING_TELEGRAM_CHAT_ID }} \
    -F document=@$LOG_FILE \
    -F caption="Build log: ${GITHUB_REPOSITORY} (${GITHUB_SHA})"
fi

exit $EXIT_CODE
