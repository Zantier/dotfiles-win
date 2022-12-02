# This file should be sourced from .bashrc

# Example .bashrc:

## 47 light gray, 102 light green, 103 light yellow, 104 light blue, 105 light magenta, 106 light cyan, 107 white
#prompt_color="105"
#alias ggmail='git init;git config user.name "YourName";git config user.email yourname@gmail.com'
## If __git_ps1 command not found
##source /etc/bash_completion.d/git-prompt
#source ~/.my.sh

# If not running interactively, don't do anything
[[ $- == *i* ]] || return

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

export EDITOR=nvim
export PATH=$HOME/.local/bin:$PATH
export DISPLAY=:0.0

# Run the function
PROMPT_COMMAND=__prompt_command
__prompt_command() {
    local EXIT="$?"
    # Color of square
    local prompt_color="\[\e[0;${prompt_color:-105}m\]"
    local error_color="\[\e[0;41m\]"
    local square=''
    if [ $EXIT != 0 ]; then
        col='\[\e[0;41m\]'
        square="${error_color}${EXIT}${prompt_color} \[\e[0m\]"
    else
        col='\[\e[0;105m\]'
        square="${prompt_color} \[\e[0m\]"
    fi

    local git_prompt='$(__git_ps1 " (%s)")'
    PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\]${git_prompt} ${square} "
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

# ranger - on close, change bash directory
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
bind '"\C-g":"ranger-cd\C-m"'

# Allow aliases to be run in sudo
# http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

alias l='ls -la --color=auto'
alias ls='ls --color=auto'
alias vi=vim
alias grep='grep --color=always'
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
