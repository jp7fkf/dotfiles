#!/bin/bash

DOT_DIRECTORY="${HOME}/dotfiles"
SPECIFIC_FILES="" # whitespace to separate multiple files

# for dotfiles and specific files
for f in .??* ${SPECIFIC_FILES}
do
  # ignore files
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".ssh" ]] && continue
  [[ ${f} = ".credentials" ]] && continue
  [[ ${f} = ".config" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".gitignore_template" ]] && continue
  [[ ${f} = ".gitmodules" ]] && continue
  [[ ${f} = ".DS_Store" ]] && continue
  [[ ${f} = ".travis.yml" ]] && continue
  [[ ${f} = ".editorconfig" ]] && continue
  [[ ${f} = "sublimetext3" ]] && continue
  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done

# pull snmp mibs
curl -fsSL https://raw.githubusercontent.com/prometheus/snmp_exporter/main/generator/Makefile -o .snmp/Makefile
make --directory .snmp mibs

echo $(tput setaf 2)Deploy dotfiles complete! ✔︎$(tput sgr0)
