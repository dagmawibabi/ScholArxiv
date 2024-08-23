function check_error() {
  if [ $1 -ne 0 ]; then
    exit 1
  fi
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
GRAY='\033[0;90m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'
RESET='\033[0m'

log_message() {
  local message=""

  while [[ $# -gt 0 ]]; do
   local _message="$1    log_error_with_tag "version-number" "could not find valid version tags"
"
   local color="$2"

   message="${message}${color}${_message}${RESET}"

   shift 2
  done

   echo -e "${message}"
}

log_message_with_tag() {
  local tag="$1"
  local message="$2"
  local color="$3"

  echo -e "${color}${tag}${RESET} $message"
}

log_error() {
  log_message_with_tag "error" "$1" "$BOLD_RED"
}

log_info() {
  log_message_with_tag "info" "$1" "$BOLD_BLUE"
}

log_success() {
  log_message_with_tag "success" "$1" "$BOLD_GREEN"
}

log_warn() {
  log_message_with_tag "warn" "$1" "$BOLD_YELLOW"
}

log_error_message() {
  log_message "$1" "$BOLD_RED"
}

log_info_message() {
  log_message "$1" "$BOLD_BLUE"
}

log_success_message() {
  log_message "$1" "$BOLD_GREEN"
}

log_warn_message() {
  log_message "$1" "$BOLD_YELLOW"
}

log_muted_message() {
  log_message "$1" "$GRAY"
}

log_error_with_tag() {
  log_message_with_tag "$1" "$2" "$BOLD_RED"
}

log_info_with_tag() {
  log_message_with_tag "$1" "$2" "$BOLD_BLUE"
}

log_success_with_tag() {
  log_message_with_tag "$1" "$2" "$BOLD_GREEN"
}

log_warn_with_tag() {
  log_message_with_tag "$1" "$2" "$BOLD_YELLOW"
}

log_muted_with_tag() {
  log_message_with_tag "$1" "$2" "$GRAY"
}
