# This file should be sourced from .bashrc

# Example .bashrc:

#alias ggmail='git config user.name "YourName";git config user.email yourname@gmail.com'
#
#test -f ~/.my.sh && source ~/.my.sh

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

export EDITOR=vim
export PATH=$HOME/.local/bin:$PATH
export DISPLAY=:0.0

# Run the function
PROMPT_COMMAND=__prompt_command
__prompt_command() {
	local EXIT="$?"
	# Color of square
	local col=''
	local square=''
	if [ $EXIT != 0 ]; then
		col='\[\e[0;41m\]'
		square="${col} ${EXIT} \[\e[0m\]"
	else
		col='\[\e[0;105m\]'
		square="${col} \[\e[0m\]"
	fi

	local git_prompt='$(__git_ps1 " (%s)")'
	PS1="\[\e]0;\w\a\]\[\e[33m\]\w\[\e[0m\]${git_prompt} ${square} "
}

# Allow aliases to be run in sudo
# http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

alias ll='ls -la --color=auto'
alias ls='ls --color=auto'
alias vi=vim
alias less='less -R' #-R does colors? http://www.ex-parrot.com/pdw/cdiff.html
alias grep='grep --color=always'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias cdiff='diff --color'

alias gb='git branch'
alias gch='git checkout'
alias gcom='git commit'
alias gcomam='git commit --amend'
alias gcomamno='git commit --amend --no-edit'
alias gd='git diff'
alias gdc='git diff --cached'
for i in {1..9}; do alias "gd${i}"="git diff HEAD~${i}"; done
alias gpr='git pull --rebase'
alias gre='git rebase'
alias grecon='git rebase --continue'
alias gs='git status'
alias gsh='git show'