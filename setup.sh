#!/bin/bash

DOT_DIRECTORY="${HOME}/dotfiles"
SPECIFY_FILES="" # 複数ファイルは""の中に半角スペース空けで入力しましょう

# ドットファイルとドットファイル以外の特定ファイルを回す
for f in .??* ${SPECIFY_FILES}
do
  # 無視したいファイルやディレクトリを追加
  [[ ${f} = ".git" ]] && continue
  [[ ${f} = ".gitignore" ]] && continue
  [[ ${f} = ".gitmodules" ]] && continue
  [[ ${f} = ".DS_Store" ]] && continue
  [[ ${f} = ".travis.yml" ]] && continue
  [[ ${f} = "sublimetext3" ]] && continue
  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
echo $(tput setaf 2)Deploy dotfiles complete! ✔︎$(tput sgr0)
