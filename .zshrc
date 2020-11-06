########################################
# JP7FKF's zshrc
# License : MIT
# http://mollifier.mit-license.org/
########################################

#重複削除
typeset -U path PATH

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
alias mkdir='mkdir -p'
alias sudo='sudo '
alias -g L='| less'
alias -g G='| grep'
alias grep='grep --color=auto'
alias date_iso8601='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias lower='tr "[:lower:]" "[:upper:]"'
alias upper='tr "[:upper:]" "[:lower:]"'

# useralias
alias gitcmtnow='git commit -m "`date "+%Y-%m-%d %H:%M:%S %Z"`"'
alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin brew"

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

function rdpasswd (){
  echo $(cat /dev/urandom | LC_ALL=C tr -dc '[:alnum:]' | head -c $1)
}

function heic2jpegall (){
  echo $(find $1 -name '*.HEIC' | xargs -IT basename T .HEIC | xargs -IT sips --setProperty format jpeg $1/T.HEIC --out $1/T.jpg;)
}

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
  zle clear-screen
}
zle -N peco-ssh
bindkey 'SS' peco-ssh

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

# vim:set ft=zsh:

export PATH="/usr/local/sbin:${HOME}/.bin:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

## pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

export PGDATA=/usr/local/var/postgres

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

## goenv
export GOENV_ROOT="$HOME/.goenv"
export GOPATH=$HOME/dev/godev
export GOBIN=$GOPATH/bin
export PATH="$GOBIN:$GOENV_ROOT/bin:$PATH"
if which goenv > /dev/null; then eval "$(goenv init -)"; fi

## nodebrew
export NODEBREW_ROOT=$HOME/.nodebrew/nodebrew
export PATH=$NODEBREW_ROOT/current/bin:$PATH

## texlive
export PATH="/Library/TeX/texbin:/usr/local/texlive/2015/bin/x86_64-darwin:$PATH"

## additional envs
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PLANTUML_LIMIT_SIZE=16384
