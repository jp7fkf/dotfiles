#! /bin/bash

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

DOTCONFIG_DIRECTORY="${HOME}/dotfiles/dotconfig"
CONFIG_DIRECTORY="${HOME}/.config"
SPECIFIC_FILES="" # whitespace to separate multiple files
cd "${HOME}/dotfiles/dotconfig"

# create .config if not exists.
mkdir -p ${CONFIG_DIRECTORY}

# for dotfiles and specific files
for f in * .??* ${SPECIFIC_FILES}
do
  # ignore files
  [[ ${f} = "setup.sh" ]] && continue
  [[ ${f} = "README.md" ]] && continue
  [[ ${f} = ".??*" ]] && continue

  if [ $DRYRUN -eq 0 ]; then
    ln -snfv ${DOTCONFIG_DIRECTORY}/${f} ${CONFIG_DIRECTORY}/${f}
  else
    echo "ln -snfv ${DOTCONFIG_DIRECTORY}/${f} ${CONFIG_DIRECTORY}/${f}"
  fi
done
echo $(tput setaf 2)Deploy dotfiles complete! ✔︎$(tput sgr0)
