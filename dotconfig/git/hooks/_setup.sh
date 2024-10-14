#!/bin/bash

GIT_HOOKS_DIR="${HOME}/.config/git/hooks"

echo '#!/bin/bash' >> hooks_template
echo '' >> hooks_template
echo 'source `dirname ${0}`/_local-hook-exec' >> hooks_template

# for homebrew(macos)
ls `brew --prefix git`/share/git-core/templates/hooks | sed s/.sample//g | xargs -I{} cp -n hooks_template ${GIT_HOOKS_DIR}/{}

chmod 700 ${GIT_HOOKS_DIR}/*
rm hooks_template
