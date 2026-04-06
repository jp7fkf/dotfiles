#!/usr/bin/env bash
#set -o errexit
set -o nounset
set -o pipefail


SOURCE_DIRECTORY="${HOME}/dotfiles"
TARGET_DIRECTORY=${HOME}
SPECIFIC_FILES="" # whitespace to separate multiple files

# for dotfiles and specific files
for f in .??* ${SPECIFIC_FILES}
do
  # ignore files
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".ssh" ]] && continue
  [[ ${f} = ".credentials" ]] && continue
  [[ ${f} = ".config" ]] && continue
  [[ ${f} = ".docker" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".gitignore_template" ]] && continue
  [[ ${f} = ".gitmodules" ]] && continue
  [[ ${f} = ".DS_Store" ]] && continue
  [[ ${f} = ".travis.yml" ]] && continue
  [[ ${f} = "sublimetext3" ]] && continue
  [[ ${f} = "Alfred" ]] && continue
  cp -r "${TARGET_DIRECTORY}/${f}" "${SOURCE_DIRECTORY}/"
  ln -snfFv "${SOURCE_DIRECTORY}/${f}" "${TARGET_DIRECTORY}/${f}"
done

# pull snmp mibs
curl -fsSL https://raw.githubusercontent.com/prometheus/snmp_exporter/main/generator/Makefile -o .snmp/Makefile
PATH=$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH make --directory .snmp mibs

# make symlink for xbar plugins
ln -s ~/.bitbar/Enabled/* ~/Library/Application\ Support/xbar/plugins

# setup secretlint
curl -fsSL https://api.github.com/repos/secretlint/secretlint/releases/latest | jq -r ".assets[] | select(.name | contains(\"`uname -o | tr "[:upper:]" "[:lower:]"`\") and contains(\"`uname -m|tr "[:upper:]" "[:lower:]"`\")) | .browser_download_url" | xargs -I_ curl -sSL _ -o .bin/secretlint && chmod +x .bin/secretlint
# setup imgcat
curl -fsSL https://iterm2.com/utilities/imgcat -o .bin/imgcat && chmod +x .bin/imgcat

# for terraform provider cache
mkdir -p $HOME/.terraform.d/plugin-cache

# deploy dotconfigs
./dotconfig/setup.sh
./.docker/setup.sh
#./Alfred/setup.sh
# deploy dotssh(manually)
# ./.ssh/setup.sh

echo $(tput setaf 2)["$0"] Deploy dotfiles complete! ✔︎$(tput sgr0)

brew bundle upgrade --global --cleanup --force
brew cleanup --prune=all
