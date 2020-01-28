#!/bin/bash

DOT_DIRECTORY="${HOME}/dotfiles"
SPECIFIC_FILES="" # whitespace to separate multiple files

# for dotfiles and specific files
for f in .??* ${SPECIFIC_FILES}
do
  # ignore files
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".gitignore_template" ]] && continue
  [[ ${f} = ".gitmodules" ]] && continue
  [[ ${f} = ".DS_Store" ]] && continue
  [[ ${f} = ".travis.yml" ]] && continue
  [[ ${f} = "sublimetext3" ]] && continue
  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
echo $(tput setaf 2)Deploy dotfiles complete! ✔︎$(tput sgr0)
