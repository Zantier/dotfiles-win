# This file should be sourced from .bashrc

# Example .bashrc:

#prompt_color="105"
#alias ggmail='git init;git config user.name "YourName";git config user.email yourname@gmail.com'
#
#test -f ~/.my.sh && source ~/.my.sh

# If not running interactively, don't do anything
[[ $- == *i* ]] || return

test -f ~/.git-prompt.sh && source ~/.git-prompt.sh
# Programmable completion enhancements.
# ~/.bash_completion is sourced last.
test -f /etc/bash_completion && source /etc/bash_completion

# Don't wait for job termination notification
set -o notify

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Change ls colours.
#export LS_COLORS='ow=01;36;40'
# Disable bell in less
export LESS="$LESS -R -Q"

export EDITOR=vim
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
alias less='less -R' #-R does colors? http://www.ex-parrot.com/pdw/cdiff.html
alias grep='grep --color=always'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias cdiff='diff --color'

# https://www.electricmonk.nl/log/2015/06/22/keep-your-home-dir-in-git-with-a-detached-working-directory/
# Move dotfiles ~/.git folder to ~/.dotfiles/.git, then use this command
alias dgit='git --git-dir ~/.dotfiles/.git --work-tree=$HOME'

git_aliases=(
    'ga add'
    'gb branch'
    'gch checkout'
    'gcom commit'
    'gcomam commit --amend'
    'gcomamno commit --amend --no-edit'
    'gd diff'
    'gdc diff --cached'
    'gpr pull --rebase'
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
    alias d$short='git --git-dir ~/.dotfiles/.git --work-tree=$HOME '"$long"
done
