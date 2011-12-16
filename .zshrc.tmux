
#This sets up a disconnected irc session if one doesn't exist
#Then this loads the connecting session into tmux with exec
#Switching between sessions is easy with "tmux switch-client -t <name>"
#Load TMUX
if [[ -z $TMUX ]]; then
   #Start the Tmux Server
   tmux start-server

   if [[ -z $(tmux list-sessions | grep irc) && $myhost == "iridium" ]]; then
      echo "IRC Session does not exist, attemplting to start"
      tmux new-session -d -s irc -n "irssi" 'irssi' > /dev/null 2>&1
   fi

   #Start the fried session and attach to it
   tmux new-session -d -s fried > /dev/null 2>&1

   exec tmux -2 attach-session -t fried
fi


typeset -ga preexec_functions 

#This is a nifty way to get enviroment varibles from your connecting session in a tmux session
#Like SSH agent or kerberos cache
if [[ -n $TMUX ]]; then
    function fixauth() {
      #TMUX gotta love it
      eval $(tmux showenv | grep -vE "^-" | awk -F = '{print "export "$1"=\""$2"\""}')
    }
    preexec_functions+='fixauth' #Run before each command
fi

