#!/bin/bash

DOT_DIRECTORY="${HOME}/dotfiles/sublimetext3/User"


if [[ `uname -m` == 'arm64' ]]; then
  # for M1 Mac
  SUBLIME_USR_DIR="${HOME}/Library/Application Support/Sublime Text 3/Packages/User"
else
  # for intel Mac
  SUBLIME_USR_DIR="${HOME}/Library/ApplicationSupport/Sublime Text 3/Packages/User"
fi

SPECIFY_FILES="" # whitespace to separate multiple files
if [ ${DOT_DIRECTORY} != $(pwd) ]; then
  echo "error: this script should be executed at own dir."
  exit 1
fi

# dotfiles and specific files
for f in * ${SPECIFY_FILES}
do
  # ignore files
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".gitmodules" ]] && continue
  [[ ${f} = ".DS_Store" ]] && continue
  [[ ${f} = "setup.sh" ]] && continue
  ln -snfv "${DOT_DIRECTORY}/${f}" "${SUBLIME_USR_DIR}/${f}"
done
echo $(tput setaf 2)Deploy dotfiles complete! ✔︎$(tput sgr0)
