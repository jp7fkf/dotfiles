#!/usr/bin/env bash
#set -o errexit
set -o nounset
set -o pipefail

DRYRUN=0
while getopts hd OPTS; do
  case "$OPTS" in
    h) echo "usage: ./setup.sh [options]"
       echo "options: -h show help"
       echo "         -d dry-run"
       exit 0;;
    d) DRYRUN=1;;
    *) echo "unknown args";
       exit 1;;
  esac
done

SOURCE_DIRECTORY="${HOME}/dotfiles/Alfred"
if [[ `uname -m` == 'arm64' ]]; then
  # for M1 Mac
  TARGET_DIRECTORY="${HOME}/Library/Application Support/Alfred"
else
  # for intel Mac
  TARGET_DIRECTORY="${HOME}/Library/ApplicationSupport/Alfred"
fi

SPECIFIC_FILES="" # whitespace to separate multiple files

# create Alfred if not exists.
mkdir -p "${TARGET_DIRECTORY}"

cd "${SOURCE_DIRECTORY}"
# for dotfiles and specific files
for f in * .??* ${SPECIFIC_FILES}
do
  # ignore files
  [[ ${f} = "setup.sh" ]] && continue
  [[ ${f} = "README.md" ]] && continue
  [[ ${f} = ".??*" ]] && continue

  if [ $DRYRUN -eq 0 ]; then
    cp -r ${TARGET_DIRECTORY}/${f} ${SOURCE_DIRECTORY}/
    ln -snfv ${SOURCE_DIRECTORY}/${f} ${TARGET_DIRECTORY}/
  else
    echo "cp -r ${TARGET_DIRECTORY}/${f} ${SOURCE_DIRECTORY}/"
    echo "ln -snfv ${SOURCE_DIRECTORY}/${f} ${TARGET_DIRECTORY}/"
  fi
done
echo $(tput setaf 2)["$0"] Deploy dotfiles complete! ✔︎$(tput sgr0)
