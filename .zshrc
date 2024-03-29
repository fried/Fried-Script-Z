###############################################################################
# Fried Script Z by Jason Fried <zshrc[at]jasonfried.info>    Standard Distro #
# INFO availible at https://github.com/fried/Fried-Script-Z.git               #
# Copyright (c) 2022, Jason Fried. All rights reserved.  BSD 2-Clause License #
# License Stmt: https://github.com/fried/Fried-Script-Z/blob/master/LICENSE   #
###############################################################################
# !!!DO NOT MAKE CHANGES TO THIS FILE THEY WILL BE LOST AFTER A 'getzshrc'!!! #
#        !!! Make ANY CHANGES YOU WISH TO KEEP IN '.zshrc.local' !!!          #
###############################################################################

#zFried Script versionreload
zshrcversion='23.07'

#set a good umask
umask 022

#Everything beyond this point is interactive shell
[[ -z "$prompt" ]] && return
[[ "$TERM" == "nuclide" ]] && return

#clean the env 
unalias -m "*" #Do not force alias on me buddy

#Make sure this alias gets created, before any scripting errors can possibly 
#prevent it.
alias reload='source ~/.zshrc'

#Remove Duplicates from Certain Arrays Automaticly
typeset -U path cdpath fpath manpath

#emergency Path if non is set
if [[ -z "$path" ]]; then
    path=(/usr/bin /bin);
fi

#Build the path, if the path exists
dpath=()
# Build out the possible paths for binaries. 
foreach suffix ( bin sbin )
    foreach dir ( ~/ /usr/local/ /usr/ / /opt/ )
        if [[ -d $dir$suffix ]]; then
            dpath+=$dir$suffix
        fi
    end
    unset dir
end
unset suffix
# Add some other things and check for existence of the provided $PATH
foreach dir ( /usr/games /usr/X11R6/bin /usr/kerberos/bin ~/tools $path )
    if [[ -d $dir ]]; then
        dpath+=$dir
    fi
end
path=($dpath)
export PATH
unset dir
unset dpath

#Enviroment Var Block

#If Vim is there lets use it
if [[ -n $(which vim) ]]; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

if [[ -n $(which less) ]]; then
    export PAGER=less
else
    export PAGER=more
fi

export BLOCKSIZE=1024

#OS Identification
uname=$(uname); #Pull out the os could be useful

#Set Some easy to see colors
export LS_COLORS='no=00:fi=00:di=00;36:ln=00;35:pi=01;34:do=01;34:bd=01;33:cd=00;33:or=01;35:so=01;34:su=00;31:sg=01;31:tw=01;37:ow=00;33:st=01;37:ex=00;32:mi=01;35:'

#Set some zsh completion Options
autoload -U compinit
compinit -C
#bashcompinit
#Complete my dot files please
_comp_options+=(globdots)
zmodload -i zsh/complist
fignore='.o' #Ignore .o files in filename completiong
setopt NO_ALWAYS_LAST_PROMPT #Print a new prompt after a list completion. 
#Case-Insensitive (all)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#Color File Completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 

HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY #Append not replace
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY #Safer history expantion :)
alias loadhistory='fc -RI' #Load lines from the history file
alias dumphistory='fc -W' #Write out the history

#Watch People :)
#LOGCHECK=10
#watch=all

setopt ALWAYS_TO_END
setopt CHASE_DOTS
setopt CHASE_LINKS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt NO_PUSHD_TO_HOME #Lets not go home, use where we are
setopt MARK_DIRS #Put / after directories on completions and expantions

setopt NO_CLOBBER
setopt IGNORE_EOF
setopt NO_BG_NICE #Let me decide my own nice level kthx
setopt NO_CHECK_JOBS #I know they are there don't remind me
setopt NO_HUP #I put them in the background I wan't them to stay
setopt NOTIFY #Let me know my job status
setopt NO_BEEP
setopt NO_NOMATCH #Do not warn me about no match just leave it

#Make the enviroment more friendly to terminals
bindkey -e #Select Emacs bindings
bindkey "^W" backward-delete-word
bindkey "\e[3~" delete-char
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
bindkey "\177" backward-delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[D" backward-char
bindkey "^[[C" forward-char
#bindkey "^[[A" up-history
#bindkey "^[[B" down-history
bindkey "^[[4~" end-of-line
bindkey "^[[5~" history-search-backward
bindkey "^[[6~" history-search-forward
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

#Remap Keys for up an down to history search back and forward
#This is an attempt to make history searching better with C-r or !word [tab]
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey ' ' magic-space #On space expand history vars

echo $(command date '+%a %h %d %r %Z %Y')
echo "Interactive \e[0;1;34mLogin\e[0m, Fried Script Z $zshrcversion."
if [[ $SHLVL -eq 1 || ( -n $TMUX && $SHLVL -eq 2 ) ]]; then #Only post this in the top most shell
    echo "Terminal type set to \e[1;33m$TERM\e[0m on $TTY."
    echo "Using \e[31mzsh\e[0m as shell with \e[31m$uname\e[0m instructions."
else
    echo "Fried Script - Current Shell Depth ${SHLVL}"
fi
#Set a colorful prompt that identifies the user and current host. 
PROMPT=$'%{\e[0;1;34m%}[%{\e[31m%}%n%{\e[34m%}@%{\e[33m%}%m%{\e[34m%}]%{\e[31m%}:%{\e[32m%}%/%(!.%{\e[31m%}>.%{\e[0m%}>)%{\e[0m%} '
RPROMPT=

altprompt () {
    echo "Reload to undo. Enjoy"
    PROMPT=$'%{\e[0;1;34m%}[%{\e[31m%}%n%{\e[34m%}@%{\e[33m%}%m%{\e[34m%}]%(!.%{\e[31m%}>.%{\e[0m%}>)%{\e[0m%} '
    RPROMPT+=$'%{\e[0;1;34m%}[%{\e[32m%}%/%{\e[34m%}]%{\e[0m%}'  
}

#Change the title on directory changes
set_xterm_title () {
    if [[ $TERM == *xterm* ]]; then
        print -Pn "\e]0;$@\007"
    fi
}

set_screen_title () {
    [[ -n $STY ]] && print -Pn "\ek$@\e\\"
}

chpwd () {
    [[ -t 1 ]] || return
    if [[ $TERM == *xterm* ]]; then
        set_xterm_title "%n@%M : %/       ::        Fried Script Z ${zshrcversion}"
        [[ -n $STY ]] && set_screen_title "%n@%m:%/"
    fi
}
chpwd #Set it 

#OS Based Alias and Settings
case "$uname" in
    (Darwin|FreeBSD)
        export LSCOLORS=gxfxExExcxDxdxbxBxhxdx #bsd & darwin
        export CLICOLOR
        ;& #Fall Through for more matches :)
    Darwin)
        alias ls='ls -GFCah'
        gettool=(curl -O) #Arguments Passed
        ;;
    Linux)
        alias ls='ls --color=auto -FhCa'
        gettool=(wget -q)
        ;;
    FreeBSD)
        alias ls='ls -FCGogah'
        gettool='fetch'
        ;;
    *)
        getttool='NONE'
        ;;
esac

#Get New Versions of this script
#Safer updates
getzshrc () {
    URL='https://raw.githubusercontent.com/fried/Fried-Script-Z/'
    branch=${1=stable} #Allow the picking of a branch :) 
    if [[ $gettool != "NONE" ]]; then
        setopt NO_PUSHD_IGNORE_DUPS #Suppress error if we start out in home
        pushd ~ #Move to home dir
        mv -f .zshrc .zshrc.old #Save the old one
        echo "$URL${branch}/.zshrc"
        $gettool "$URL${branch}/.zshrc"
        if [[ $? -eq 0 ]]; then
            echo "Use 'zshcompare' to review changes (RECOMENDED)"
            alias zshcompare='diff -udB ~/.zshrc.old ~/.zshrc | less'
            echo "Use 'reload' to use these settings now"
            echo "Use 'revert' to use old version"
            alias revert='mv -f ~/.zshrc.old ~/.zshrc&&unalias revert'
            popd #go back to what we were doing
        else
            mv -f .zshrc.old .zshrc #Restore the old, we failed
        fi
        setopt PUSHD_IGNORE_DUPS #Restore behavior 
    else
        echo "Disabled, lacking a file fetch utility for your OS"
    fi
}


#Useful Aliases
alias depth='echo "You are currently at a shell depth of ${SHLVL}"'
alias version='echo "Fried Script Z $zshrcversion"'
#Be Safe :)
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
#Grep insensetively
alias grep='grep -i'
#Grep out my procs
psgrep () { ps auxww | grep $@ }
alias mildate='command date'

if [[ -n $(which bc) ]]; then # I seem to use this alot, and it rots my brain
   calc() { echo $@ | bc -l }
fi

#Forward my ssh agent always
alias ssh='ssh -A'
alias sshkeys='ssh-add -l'

if [[ -n $(which less) ]]; then 
   alias more='less' #Yes less is more
fi

#Perl to the rescue
if [[ -n $(which perl) ]]; then
    if [[ $uname == "Darwin" ]]; then
        alias ped='perl -npe'
    else
        alias ped='perl -i.bak -npe' #Why sed when you can ped
    fi
    perl -e "use LWP::Simple" &> /dev/null
    if [[ $? -eq 0 ]]; then
        alias phttpcat='perl -MLWP::Simple -e "exit is_error getprint shift"'
        pwget () {
            phttpcat $1 > $(basename $1)    
        }
        if [[ $gettool == "NONE" ]]; then
            gettool='pwget' #Perl to save the day
        fi
    fi   
fi

alias become='sudo -s -H -u'
if [[ $EDITOR == "vim" ]]; then
    alias vi='vim'
fi
alias cls='clear'
alias stack='dirs -l'

#Hooks for Plugins
typeset -gUa preexec_functions
typeset -gUa precmd_functions
typeset -gUa chpwd_functions

#List of plugins not to load
NO_FRIED_LOAD=()

#Load local configurations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

#Load system local config
hostname=$(hostname | cut -d . -f 1) # SunOS safe :)
[[ -f ~/.zshrc.$hostname ]] && source ~/.zshrc.$hostname
unset hostname

#Load My Plugins
setopt NULL_GLOB # Ingore no match
foreach PLUGIN_FILE (~/.zsh.d/*.z)
    unsetopt NULL_GLOB #Don't want plugins to get a strang option set
    local PLUGIN=$(basename $PLUGIN_FILE .z)
    #Unless indicated load the found plugin
    [[ $NO_FRIED_LOAD =~ $PLUGIN ]] || source $PLUGIN_FILE
end
unsetopt NULL_GLOB
unset PLUGIN_FILE
###############################################################################
# vim: set tabstop=4:softtabstop=4:shiftwidth=4:expandtab                     #
#                       THIS IS THE END OF Fried Script Z                     #
###############################################################################
