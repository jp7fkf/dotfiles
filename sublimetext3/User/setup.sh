#!/bin/bash

DOT_DIRECTORY="${HOME}/dotfiles/sublimetext3/User"
SUBLIME_USR_DIR="${HOME}/Library/ApplicationSupport/Sublime Text 3/Packages/User"

SPECIFY_FILES="" # 複数ファイルは""の中に半角スペース空けで入力しましょう
if [ ${DOT_DIRECTORY} != $(pwd) ]; then
  echo "error: this script should be executed at own dir."
  exit 1
fi

# ドットファイルとドットファイル以外の特定ファイルを回す
for f in * ${SPECIFY_FILES}
do
  # 無視したいファイルやディレクトリを追加
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".gitmodules" ]] && continue
  [[ ${f} = ".DS_Store" ]] && continue
  [[ ${f} = "setup.sh" ]] && continue
  ln -snfv "${DOT_DIRECTORY}/${f}" "${SUBLIME_USR_DIR}/${f}"
done
echo $(tput setaf 2)Deploy dotfiles complete! ✔︎$(tput sgr0)
