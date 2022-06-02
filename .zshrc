########################################
# JP7FKF's zshrc
# License : MIT
# http://mollifier.mit-license.org/
########################################

# environs
export LANG=ja_JP.UTF-8

# editor
export EDITOR=vim

# 色を使用出来るようにする
autoload -Uz colors
colors

# diffをcolordiffに
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

## KEY BINDING ##
# emacs like keybinding
bindkey -e
# ctrl+allow for moving corsor each word
# TODO: DISABLE mission control keymap in macOS default
bindkey ";5C" forward-word
bindkey ";5D" backward-word

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# prompt
# one line
# PROMPT="%~ %# "
# dual lines
PROMPT="%{${fg[green]}%}[%n@%M %D %*]%{${reset_color}%} %~
%# "

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# completion
function _ssh {
  compadd `find ~/.ssh -type f | xargs -I _ fgrep -i 'Host ' _ | awk '{print $2}' | sort`;
}

#for zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# enable completion
autoload -Uz compinit
compinit -u

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

########################################
# vcs_info (git/subversion info)
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

########################################
# options
# print japanese file name
setopt print_eight_bit

setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# share zsh_history in multiple zsh_process
setopt share_history

# don't add duplicate commands to history
setopt hist_ignore_all_dups

# don't add starting with space commands to history
setopt hist_ignore_space

# redule blanks when add to history
setopt hist_reduce_blanks

# enable wildcard extension
setopt extended_glob

########################################
# keybinding

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# alias
alias ssh='ssh -o ServerAliveInterval=60'
alias la='ls -a'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias m='make'
alias mkdir='mkdir -p'
alias -g L='| less'
alias -g G='| grep'
alias grep='grep --color=auto'
alias date_iso8601='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias upper='tr "[:lower:]" "[:upper:]"'
alias lower='tr "[:upper:]" "[:lower:]"'
alias ssh-password='ssh -o PreferredAuthentications=password'
alias gitcmtnow='git commit -m "`date "+%Y-%m-%d %H:%M:%S %Z"`"'
alias gitcmtwip='git commit -m "wip"'
alias relogin='exec $SHELL -l'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

########################################
# functions
function gitgraph () {
  git graph
  zle accept-line
}
zle -N gitgraph
bindkey 'GG' gitgraph

function ssh-add-all (){
  find ~/.ssh -name 'id_*' | grep -v .pub | xargs -I _ ssh-add _
}

function rdpasswd (){
  echo $(cat /dev/urandom | LC_ALL=C tr -dc '[:alnum:]' | head -c $1)
}

function heic2jpegall (){
  echo $(find $1 -name '*.HEIC' | xargs -IT basename T .HEIC | xargs -IT sips --setProperty format jpeg $1/T.HEIC --out $1/T.jpg;)
}

function smtpauth_plain (){
  printf "%s\0%s\0%s" $1 $1 $2 | openssl base64 -e | tr -d '\n'; echo
}

function docker-taglist (){
  local image=${1}
  local limit=${2:=1}

  # official image exists under /library path
  if [[ ! "${image}" =~ ^.+/.+$ ]]; then
    image="library/${image}"
  fi
  local next="https://registry.hub.docker.com/v2/repositories/${image}/tags"
  local names
  while [[ ${limit} -gt 0 && ${next} != "null" ]]
  do
    response=$(curl --silent --show-error "${next}")
    names="${names}\n$(echo ${response} | jq -r ".results|map_values(\"${image}:\"+.name)|.[]")"
    next=$(echo ${response} | jq -r .next)
    limit=$((${limit}-1))
  done
  echo -e "${names}"
}

function list_licenses (){
  curl -s https://api.github.com/licenses | jq -r .
}

function replace_all (){
  local -A opt
  zparseopts -D -A opt -- h -help v -version c -check d -delete
  if [[ -n "${opt[(i)-h]}" ]] || [[ -n "${opt[(i)--help]}" ]] || [[ $# -ne 3 ]]; then
    echo 'replace_all: replace all word of file under selected path.'
    echo '[usage]: replace_all [options] <replace_from_str> <replace_to_str> <dir>'
    echo '[options]:'
    echo '  -h, --help: show this help.'
    echo '  -v, --version: show version'
    echo '  -c, --check: show all files/lines which are changed by execution. This option will not change all files.'
    echo '  -d, --delete: delete characters which are matched to the regular expressions. the replaced patterns are ignored.'
    return 0
  fi
  if [[ -n "${opt[(i)-v]}" ]] || [[ -n "${opt[(i)--version]}" ]]; then
    echo 'replace_all version 0.0.1'
    return 0
  fi
  if [[ -n "${opt[(i)-c]}" ]] || [[ -n "${opt[(i)--check]}" ]]; then
    grep -r "$1" $~3
  elif [[ -n "${opt[(i)-d]}" ]] || [[ -n "${opt[(i)--delete]}" ]]; then
    grep -r "$1" $~3 -l | xargs gsed -i "/$1/d"
  else
    grep -r "$1" $~3 -l | xargs gsed -i "s/$1/$2/g"
  fi
}
alias replace_all='noglob replace_all'

############## pdf minimize ################
function pdfmin()
{
    local cnt=0
    for i in $@; do
        gs -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.4 \
           -dPDFSETTINGS=/ebook \
           -dNOPAUSE -dQUIET -dBATCH \
           -sOutputFile=${i%%.*}.min.pdf ${i} &
        (( (cnt += 1) % 4 == 0 )) && wait
    done
    wait && return 0
}

############## peco&ghq ################
function peco-ghq () {
  local selected_repo=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_repo" ]; then
    BUFFER="cd $(ghq root)/${selected_repo}"
    zle accept-line
  fi
  #zle clear-screen
}
zle -N peco-ghq
bindkey 'GH' peco-ghq
#alias g='cd $(ghq root)/$(ghq list | peco)'

############## peco&hub ################
function peco-hub () {
  local selected_repo=$(ghq list | peco --query "$LBUFFER" | cut -d "/" -f 2,3)
  if [ -n "$selected_repo" ]; then
    hub browse "${selected_repo}"
  fi
}
alias gh='peco-hub'
#alias gh='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

############## peco&ssh ################
function peco-ssh () {
  local selected_host=$(find ~/.ssh -type f |
  xargs -I _ awk '
  tolower($1)=="host" {
    for (i=2; i<=NF; i++) {
      if ($i !~ "[*?]") {
        print $i
      }
    }
  }
  ' _ | sort | peco --query "$LBUFFER")
  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  #zle clear-screen
}
zle -N peco-ssh
bindkey 'SS' peco-ssh

######### peco&git checkout ############
function peco-checkout () {
  local branch=$(git branch -a | peco | tr -d ' ')
  if [ -n "$branch" ]; then
    if [[ "$branch" =~ "remotes/" ]]; then
      local b=$(echo $branch | awk -F'/' '{for(i=3;i<NF;i++){printf("%s%s",$i,OFS="/")}print $NF}')
      BUFFER="git checkout -b '${b}' '${branch}'"
      zle accept-line
    else
      BUFFER="git checkout '${branch}'"
      zle accept-line
    fi
  fi
  #zle clear-screen
}
zle -N peco-checkout
bindkey 'BB' peco-checkout

######### git-delete-squashed-branch ############
function git-delete-squashed-branch () {
  local -A opt
  zparseopts -D -A opt -- h -help v -version c -check
  if [[ -n "${opt[(i)-h]}" ]] || [[ -n "${opt[(i)--help]}" ]] || [[ $# -gt 1 ]]; then
    echo 'git-delete-squashed-branch: delete squash merged branches'
    echo '[usage]: git-delete-squashed-branch [options] [baseBranch: default branch]'
    echo '[options]:'
    echo '  -h, --help: show this help.'
    echo '  -v, --version: show version'
    echo '  -c, --check: show all branches which are deleted by execution. This option will not change all branches.'
    return 0
  fi
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | awk -F'[/]' '{print $NF}')
  if [[ -n "${opt[(i)-v]}" ]] || [[ -n "${opt[(i)--version]}" ]]; then
    echo 'git-delete-squashed-branch version 0.0.1'
    return 0
  fi
  if [[ -n "${opt[(i)-c]}" ]] || [[ -n "${opt[(i)--check]}" ]]; then
    local baseBranch=${1:=$default_branch}
    git checkout -q $baseBranch
    git for-each-ref refs/heads/ "--format=%(refname:short)" | \
    while read branch
    do
      mergeBase=$(git merge-base $baseBranch $branch)
      if [[ $(git cherry $baseBranch $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]]; then
        echo $branch
      fi
    done
  else
    local baseBranch=${1:=$default_branch}
    git checkout -q $baseBranch
    git for-each-ref refs/heads/ "--format=%(refname:short)" | \
    while read branch
    do
      mergeBase=$(git merge-base $baseBranch $branch)
      if [[ $(git cherry $baseBranch $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]]; then
        git branch -D $branch;
      fi
    done
  fi
}

######### shellcolors ############
function shellcolors () {
  echo -e "\033[1m# Basic\033[m"
  echo -e "Set   color: \"\\\033[<attribute>;<foreground>;<background>m\""
  echo -e "Reset color: \"\\\033[m"\"

  echo -e "\033[1m# Attributes:\033[m"
  echo -e "\\\033[0m\033[0mReset\033[m\\\033[m"
  echo -e "\\\033[1m\033[1mBold\033[m\\\033[m"
  echo -e "\\\033[2m\033[2mLowLuminance\033[m\\\033[m"
  echo -e "\\\033[3m\033[3mItalic\033[m\\\033[m"
  echo -e "\\\033[4m\033[4mUnderline\033[m\\\033[m"
  echo -e "\\\033[5m\033[5mBlink\033[m\\\033[m"
  echo -e "\\\033[6m\033[6mHighBlink\033[m\\\033[m"
  echo -e "\\\033[7m\033[7mInvert\033[m\\\033[m"
  echo -e "\\\033[8m\033[8mHide\033[m\\\033[m"
  echo -e "\\\033[9m\033[9mStrikethrough\033[m\\\033[m"

  echo -e "\033[1m# 16 foreground colors:\033[m"
  echo -e "\\\033[30m\033[30mBLACK\033[m\\\033[m\t\\\033[90m\033[90mLIGHT BLACK\033[m\\\033[m"
  echo -e "\\\033[31m\033[31mRED\033[m\\\033[m\t\\\033[91m\033[91mLIGHT RED\033[m\\\033[m"
  echo -e "\\\033[32m\033[32mGREEN\033[m\\\033[m\t\\\033[92m\033[92mLIGHT GREEN\033[m\\\033[m"
  echo -e "\\\033[33m\033[33mYELLOW\033[m\\\033[m\t\\\033[93m\033[93mLIGHT YELLOW\033[m\\\033[m"
  echo -e "\\\033[34m\033[34mBLUE\033[m\\\033[m\t\\\033[94m\033[94mLIGHT BLUE\033[m\\\033[m"
  echo -e "\\\033[35m\033[35mMAGENTA\033[m\\\033[m\t\\\033[95m\033[95mLIGHT MAGENTA\033[m\\\033[m"
  echo -e "\\\033[36m\033[36mCYAN\033[m\\\033[m\t\\\033[96m\033[96mLIGHT CYAN\033[m\\\033[m"
  echo -e "\\\033[37m\033[37mWHITE\033[m\\\033[m\t\\\033[97m\033[97mLIGHT WHITE\033[m\\\033[m"

  echo -e "\033[1m# 16 background colors:\033[m"
  echo -e "\\\033[40m\033[40mBLACK\033[m\\\033[m\t\\\033[100m\033[100mLIGHT BLACK\033[m\\\033[m"
  echo -e "\\\033[41m\033[41mRED\033[m\\\033[m\t\\\033[101m\033[101mLIGHT RED\033[m\\\033[m"
  echo -e "\\\033[42m\033[42mGREEN\033[m\\\033[m\t\\\033[102m\033[102mLIGHT GREEN\033[m\\\033[m"
  echo -e "\\\033[43m\033[43mYELLOW\033[m\\\033[m\t\\\033[103m\033[103mLIGHT YELLOW\033[m\\\033[m"
  echo -e "\\\033[44m\033[44mBLUE\033[m\\\033[m\t\\\033[104m\033[104mLIGHT BLUE\033[m\\\033[m"
  echo -e "\\\033[45m\033[45mMAGENTA\033[m\\\033[m\t\\\033[105m\033[105mLIGHT MAGENTA\033[m\\\033[m"
  echo -e "\\\033[46m\033[46mCYAN\033[m\\\033[m\t\\\033[106m\033[106mLIGHT CYAN\033[m\\\033[m"
  echo -e "\\\033[47m\033[47mWHITE\033[m\\\033[m\t\\\033[107m\033[107mLIGHT WHITE\033[m\\\033[m"

  echo -e "\033[1m# 256 colors:\033[m"
  echo -e "Foreground: \"\\\033[38;5;<color number>mCOLOR\\\033[m\""
  echo -e "Background: \"\\\033[48;5;<color number>mCOLOR\\\033[m\""
  seq 0 255 | xargs -I {} printf "\033[38;5;{}m{}\033[m "
  echo -e ""

  echo -e "\033[1m# 24bit colors\033[m"
  echo -e "Foreground: \"\\\033[38;2;<red(0-255)>;<green(0-255)>;<blue(0-255)>m\\\033[m\""
  echo -e "Background: \"\\\033[48;2;<red(0-255)>;<green(0-255)>;<blue(0-255)>m\\\033[m\""
}

######### mtudisc ############
function mtudisc () {
  DESTINATION=${1:-8.8.8.8}
  MAX_SIZE=${2:-65535}
  # Ctrl+C to exit
  # trap 'echo Breaked; return 2' 2
  ## check reachability
  if ! ping -c 1 "${DESTINATION}" > /dev/null; then
    echo "Cannot connect to ${DESTINATION}"
    return 2
  fi
  # binary search
  MAX=`expr ${MAX_SIZE} + 1`
  MIN=1
  echo -ne "Discover MTU: Range($MIN-$MAX)\n" >&2
  echo "OSType: $OSTYPE"
  while [ $MIN -lt $MAX ]
  do
    i=`expr '(' $MIN + $MAX ')' / 2`
    echo -ne "DataSize=$i: " >&2
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      ping -c 1 -W 1 -M do -s $i "${DESTINATION}">/dev/null 2>&1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      # Mac OSX
      ping -c 1 -t 1 -D -s $i "${DESTINATION}">/dev/null 2>&1
    else
      echo "OS not supported."
      return 2
    fi
    if [ $? -eq 0 ];then
      echo "OK" >&2
      MIN=`expr $i + 1`
      LAST_PASSED_SIZE=$i
    else
      echo "NG" >&2
      MAX=$i
    fi
  done
  echo "MTU: `expr $LAST_PASSED_SIZE + 28`"
}


######### htping ############
function htping () {
  local seq=0
  zparseopts -D -A opt -- h -help -interval:
  if [[ -n "${opt[(i)-h]}" ]] || [[ -n "${opt[(i)--help]}" ]]; then
    echo 'htping: '
    echo '[usage]: htping [options] [curlargs] <url>'
    echo '[options]:'
    echo '  -h, --help: show this help.'
    echo '  --version: show version'
    echo '  --interval: set interval with sec(default: 1)'
    return 0
  fi
  if [[ -n "${opt[(i)--version]}" ]]; then
    echo 'htping version 0.0.1'
    return 0
  fi
  local interval=1
  if [[ -n "${opt[(i)--interval]}" ]]; then
    interval=${opt[--interval]}
  fi

  while true
  do
    echo -n "seq=${seq} "
    curl ${@} -w 'code=%{http_code} http_version=%{http_version} remote_ip=%{remote_ip} bytes=%{size_download} time=%{time_total}sec\n' -o /dev/null -s
    seq=$((seq+1))
    sleep ${interval}
  done
}

########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export LSCOLORS=dxgxcxdxcxegedabagacad
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

export PATH="/usr/local/sbin:${HOME}/.bin:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [[ `uname -m` == 'arm64' ]]; then
  # for M1 mac
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin/:$PATH"
  export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
else
  # for Intel mac
  #alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin brew"
  export PATH="/usr/local:$PATH"
fi

## pyenv
if which pyenv > /dev/null; then eval "$(pyenv init --path)"; fi
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

export PGDATA=/usr/local/var/postgres

## rbenv
if [ -e ~/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
fi

## goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
if which goenv > /dev/null; then eval "$(goenv init -)"; fi
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

## nodebrew
export NODEBREW_ROOT="$HOME/.nodebrew"
export PATH="$NODEBREW_ROOT/current/bin:$PATH"

## texlive
export PATH="/Library/TeX/texbin:/usr/local/texlive/2015/bin/x86_64-darwin:$PATH"

#重複削除
typeset -U path PATH

## terraform
export TF_CLI_ARGS_plan="--parallelism=30"
export TF_CLI_ARGS_apply="--parallelism=30"

## additional envs
export PLANTUML_LIMIT_SIZE=16384

# kubernetes
if [ -x "`which kubectl`"  ] ; then
    source <(kubectl completion zsh)
fi

# vim:set ft=zsh:
