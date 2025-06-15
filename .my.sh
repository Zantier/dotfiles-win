# This file should be sourced from .bashrc

# Example .bashrc:

## 47 light gray, 102 light green, 103 light yellow, 104 light blue, 105 light magenta, 106 light cyan, 107 white
#prompt_color="105"
#alias ggmail='git init;git config user.name "YourName";git config user.email yourname@gmail.com'
#source ~/.my.sh

# If not running interactively, don't do anything
[[ $- == *i* ]] || return

SHELL_NAME=$(basename $SHELL)

test -f ~/.git-completion.sh && source ~/.git-completion.sh
test -f ~/.git-prompt.sh && source ~/.git-prompt.sh
# Programmable completion enhancements
# ~/.bash_completion is sourced last
test -f /etc/bash_completion && source /etc/bash_completion

# Don't wait for job termination notification
set -o notify

# History Options
#
# Don't put duplicate lines in the history
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Change ls colors
#export LS_COLORS='ow=01;36;40'

# less
# Default in git is LESS=FRX
# -R Show color, output raw control characters
# -S Don't wrap, chop long lines
# -q Disable bell
export LESS=FRXq

export PATH=$HOME/.local/bin:$PATH
export DISPLAY=:0.0


# This is a very simple replacement for __git_ps1
get_git_prompt() {
    local res=$(git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (\1)/')
    echo "$res"
}


# bash uses $PROMPT_COMMAND, and zsh uses precmd()
#   which are functions run before each display of the prompt
# zero-width characters must be between
#   \[ and \] in bash
#   %{ and %} in zsh
# otherwise things like tab-complete and reverse-search mess up
PROMPT_COMMAND=__prompt_command
__prompt_command() {
    local EXIT="$?"
    # Color of square
    local prompt_color="\[\e[0;${prompt_color:-105}m\]"
    local error_color="\[\e[0;41m\]"
    local square=''
    if [ $EXIT != 0 ]; then
        square="${error_color}${EXIT}${prompt_color} \[\e[0m\]"
    else
        square="${prompt_color} \[\e[0m\]"
    fi

    local git_prompt='$(__git_ps1 " (%s)")'
    PS1="\[\e[33m\]\w\[\e[0m\]${git_prompt} ${square} "
}
precmd() {
    local EXIT="$?"
    # Color of square
    local prompt_color=$'%{\e[0;'${prompt_color:-105}m'%}'
    local error_color=$'%{\e[0;41m%}'
    local square=''
    if [ $EXIT != 0 ]; then
        square="${error_color}${EXIT}${prompt_color} "$'%{\e[0m%}'
    else
        square="${prompt_color} "$'%{\e[0m%}'
    fi

    setopt PROMPT_SUBST
    local git_prompt='$(__git_ps1 " (%s)")'
    PS1=$'%{\e[33m%}%~%{\e[0m%}'"${git_prompt} ${square} "
}


# Get information about a command
function kind() {(
    type -a "$1"
    local actual=$1
    if alias "$1" >/dev/null 2>&1; then
        local actual=$(alias "$1" | sed -E 's/^alias [^=]+='\''([^ ;'\'']+).*/\1/')
    fi

    if which "$actual" >/dev/null 2>&1; then
        local path=$(which "$actual")
        cd $(dirname "$path")
        ls -lah --color=auto "$path"
        while [ -h "$path" ]; do
            local path=$(readlink "$path")
            cd $(dirname "$path")
            ls -lah --color=auto "$path"
        done
    fi
)}


if [ $SHELL_NAME = zsh ]; then
    # ranger - on close, change directory
    function ranger-cd {
        tempfile="$(mktemp -t tmp.XXXXXX)"
        ranger --choosedir="$tempfile" "${@:-$(pwd)}" <$TTY
        test -f "$tempfile" &&
        if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
            cd -- "$(cat "$tempfile")"
        fi
        rm -f -- "$tempfile"
        precmd
        zle reset-prompt
    }
    zle -N ranger-cd
    bindkey '\C-g' ranger-cd
else
    # ranger - on close, change directory
    function ranger-cd {
        tempfile="$(mktemp -t tmp.XXXXXX)"
        ranger --choosedir="$tempfile" "${@:-$(pwd)}"
        test -f "$tempfile" &&
        if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
            cd -- "$(cat "$tempfile")"
        fi
        rm -f -- "$tempfile"
    }
    bind '"\C-g":"ranger-cd\C-m"'
fi

# Allow aliases to be run in sudo
# http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

alias l='ls -la --color=auto'
alias ls='ls --color=auto'
alias vi=vim
alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias cdiff='diff --color'

git_aliases=(
    'ga add'
    'gb branch'
    'gch checkout'
    'gcom commit'
    'gcomam commit --amend'
    'gcomamno commit --amend --no-edit'
    'gd diff'
    'gdc diff --cached'
    'gfet fetch'
    'gl log'
    'gpr pull --rebase'
    'gpush push'
    'greb rebase'
    'grebcon rebase --continue'
    'gres reset'
    'gs status'
    'gsh show'
)
for i in {1..9}; do git_aliases+=("gd${i} diff HEAD~${i}"); done

for element in "${git_aliases[@]}"; do
    short=$(echo $element | cut -d ' ' -f 1)
    long=$(echo $element | cut -d ' ' -f 2-)
    alias $short="git $long"
done

# git completion (works by default in zsh)
if [ $SHELL_NAME != zsh ]; then
    __git_complete ga git_add
    __git_complete gb git_branch
    __git_complete gch git_checkout
    __git_complete gcom git_commit
    __git_complete gcomam git_commit
    __git_complete gcomamno git_commit
    __git_complete gd git_diff
    __git_complete gdc git_diff
    __git_complete gfet git_fetch
    __git_complete gl git_log
    __git_complete gpr git_pull
    __git_complete gpush git_push
    __git_complete greb git_rebase
    __git_complete grebcon git_rebase
    __git_complete gres git_reset
    __git_complete gs git_status
    __git_complete gsh git_show
fi
