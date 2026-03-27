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

SOURCE_DIRECTORY="${HOME}/dotfiles/.ssh"
TARGET_DIRECTORY="${HOME}/.ssh"
SPECIFIC_FILES="" # whitespace to separate multiple files

# create .ssh if not exists.
mkdir -p "${TARGET_DIRECTORY}"
chmod 700 "${TARGET_DIRECTORY}"
mkdir -p "${TARGET_DIRECTORY}/conf.d"
chmod 766 "${TARGET_DIRECTORY}/conf.d"

cd "${SOURCE_DIRECTORY}"
# for dotfiles and specific files
for f in * .??* ${SPECIFIC_FILES}
do
  # ignore files
  [[ ${f} = "setup.sh" ]] && continue
  [[ ${f} = "README.md" ]] && continue
  [[ ${f} = ".??*" ]] && continue

  if [ $DRYRUN -eq 0 ]; then
    cp -r "${TARGET_DIRECTORY}/${f}" "${SOURCE_DIRECTORY}/"
    ln -snfv "${SOURCE_DIRECTORY}/${f}" "${TARGET_DIRECTORY}/${f}"
  else
    echo "cp -r ${TARGET_DIRECTORY}/${f} ${SOURCE_DIRECTORY}/"
    echo "ln -snfv ${SOURCE_DIRECTORY}/${f} ${TARGET_DIRECTORY}/${f}"
  fi
done
echo $(tput setaf 2)["$0"] Deploy dotfiles complete! ✔︎$(tput sgr0)
