# In foundry, I mostly use console.log to examine variables during development.
# So after each debugging, I endup with a lot of console.log in my code.
# This script will remove all console.log from all .sol files in a folder.
# Usage: cleanup <folder>
# Example:
#     - cleanup src
#     - cleanup scripts
#     - cleanup test

funcCleanup() {
    folder=$1:u
    find $folder -name \*.sol -exec sed -i '' '/console\.log/d' {} \;
}
alias cleanup=funcCleanup
