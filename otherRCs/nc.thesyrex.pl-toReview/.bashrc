############################################################################
############################################################################
#####                                                                 #####
#####                 This is my very qrfa BASHRC!!!                  #####
#####                                                                 #####
############################################################################
############################################################################



############################################################################
#####               Setting main variables                            #####
############################################################################

# Colorki od Mateusza :D | HOST (future feature) | 
c_nc="\[\033[0m\]"        
c_white="\[\033[1;37m\]"  
c_black="\[\033[0;30m\]"  
c_blue="\[\033[0;34m\]"   
c_lblue="\[\033[1;34m\]"  
c_green="\[\033[0;32m\]"  
c_lgreen="\[\033[1;32m\]"     # LocalHost
c_cyan="\[\033[0;36m\]"       
c_lcyan="\[\033[1;36m\]"  
c_red="\[\033[0;31m\]"    
c_lred="\[\033[1;31m\]"   
c_purple="\[\033[0;35m\]"     # FE
c_lpurple="\[\033[1;35m\]"
c_yellow="\[\033[0;33m\]"     # Storage
c_lyellow="\[\033[1;33m\]"    # LSM
c_gray="\[\033[0;37m\]"   
c_lgray="\[\033[1;37m\]"  

# Setting VIM as default editor and vim mode in bash
export TERM=xterm
VISUAL=vi; export VISUAL 
EDITOR=vi; export EDITOR
set -o vi

# Moje serwerki SSH
# IPki:
dizzy=192.168.224.100
dizzyPub=89.73.112.160		# update'owac regularnie!!!
daisy=198.199.90.38
denzil=198.199.118.70
rhel01=192.168.224.107

# Hosty emeska.pl: 
lsm01=107.170.180.126
fe01=46.101.57.206 
fe02=46.101.42.185
storage01=91.121.159.172
storage02=185.81.167.155

# AuthGate SysOps.pl:
rhqq=a.rhqq.pl


############################################################################
#####               Setting my aliases                                 #####
############################################################################

# Setting my aliases
test -s ~/.alias && . ~/.alias || true
alias 'bashlearning'='cd ~/Dropbox/WSIZ/II\ Semestr/Systemy\ operacyjne/bashscripting-training'
alias 'jdownloader'='java -jar ~/jdownloader/JDownloader.jar &'
alias 'dirs'='dirs -p'
alias 'pm-suspend'='sudo pm-suspend && dm-tool lock'

alias 'ls'='ls --color=auto' # Bardzo ważne, żeby wynik wszystkich ls'ów się ładnie kolorował! 
alias 'l'='ls -CF'
alias 'll'='ls -alh'
alias 'lll'='ls -lhF'
alias 'ld'='lll | grep ^d'
alias '..'='cd ..; ll'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias 'resetbash'='/bin/bash'
alias 'kill-chrome'="pstree -lp | egrep -o 'chrome\([0-9]*\)' | head -n 1 | grep -o '[0-9]*' | xargs kill -9"
alias 'kill-vpn'="sudo kill -9 \$(ps aux | grep [o]penvpn | awk '{print \$2}' | tr '\n' ' ')"

alias 'ipas'='ip a s'

# SSH connections aliases
alias "dizzy"="ssh-connection msyrek $dizzy"
alias "dizzyPub"="ssh-connection msyrek $dizzyPub"
alias "daisy"="ssh-connection msyrek $daisy"
alias "denzil"="ssh-connection msyrek $denzil"
alias 'rhel01'='ssh-connection msyrek 192.168.224.114'

alias "lsm01"="ssh-connection msyrek $lsm01"
alias "fe01"="ssh-connection msyrek $fe01"
alias "fe02"="ssh-connection msyrek $fe02"
alias "storage01"="ssh-connection msyrek $storage01"
alias 'rhqq'='ssh ms@a.rhqq.pl -p60'

alias 'go'='ssh-connection msyrek'
alias 'gr'='ssh-connection root'
alias 'gs'='ssh-connection ms'

alias "keys"="ssh-add ~/.ssh/keys/*.key"

alias 'zbbscreen'='keys; screen -t "ZBB" -c ~/.screenrc_zbb'
alias 'clr'='clear'

############################################################################
#####               Very helpful functions                             #####
############################################################################

# Funkcja wspomagająca cd
cdl () 
{
       cd $1
       ls -al
}

# Funkcja do laczenia sie z serwerkmi i ladowania kluczy:
ssh-connection ()
{
	if [[ $(ssh-add -l | grep -o "The") == "The" ]]
	then
		echo -e "Nie posiadasz zaladowanych kluczy. Zaladuj teraz.\n"
		keys
	fi
	ssh -X $1@$2
}

# Funkcja wspomagajaca polecenie dirs:

# Lista najczesciej uzywanych folderow (w pliku tekstowym .MostUsedFolders):
# pushd ~/Dropbox/WSIZ/II\ Semestr/Systemy\ operacyjne/bashscripting-training/ 1> /dev/null
# pushd ~/Pobrane/ 1> /dev/null
# pushd ~/Dropbox/EMESKA/RedHat/ 1> /dev/null
# pushd ~ 1> /dev/null

curr_dir=$(pwd)
# . ~/.MostUsedFolders
cd $curr_dir

# Funkcyjka
# (Źrodlo: http://aijazansari.com/2010/02/20/navigating-the-directory-stack-in-bash/)
    # An enhanced 'cd' - push directories
    # onto a stack as you navigate to it.
    #
    # The current directory is at the top
    # of the stack.

function stack_cd () {
#set -x -v 
	if [ "$1" ]; then
            # use the pushd bash command to push the directory
            # to the top of the stack, and enter that directory
		pushd "$1" > /dev/null
		else
            # the normal cd behavior is to enter $HOME if no
            # arguments are specified
 		pushd $HOME > /dev/null
	fi
#set +x +v
}
# the cd command is now an alias to the stack_cd function
alias cd=stack_cd

    # Swap the top two directories on the stack
function swap (){
        pushd > /dev/null
    }
    # s is an alias to the swap function
alias s=swap

# Pop the top (current) directory off the stack
    # and move to the next directory
    #
    function pop_stack {
        popd > /dev/null
    }
    alias p=pop_stack

#	THE MAIN PART!  #
# Display the stack of directories and prompt
    # the user for an entry.

    # If the user enters 'p', pop the stack.
    # If the user enters a number, move that
    # directory to the top of the stack
    # If the user enters 'q', don't do anything.
    
function display_stack (){
#set -x -v 
echo "Current directory: $(pwd)"
dirs -v
echo -n "#: "
read dir
        if [[ $dir = 'p' ]]; then
	pushd > /dev/null
elif [[ $dir != 'q' ]]; then
	d=$(dirs -l +$dir);
	popd +$dir > /dev/null
	pushd "$d" > /dev/null
fi
#set +x +v
}
alias d=display_stack

# ===================== GIT PROMPT    ===================================== #
  # Git branch name and state: blue=uncommited red=ahead                              
function git_prompt(){  
   unset GPROMPT                                                                       
   git status > /dev/null 2>&1 && {                                                    
     GPROMPT="${c_lgreen}("                                                            
     [[ -n $(git diff 2> /dev/null) ]] && GPROMPT="${GPROMPT}${c_red}*"                
     [[ -n $(git status 2> /dev/null | grep ahead) ]] && GPROMPT="${GPROMPT}${c_blue}*"
     GBRANCH=$(git branch 2> /dev/null | grep '*' | cut -d' ' -f2 )                    
     GPROMPT="${GPROMPT}${c_green}${GBRANCH}${c_lgreen})"                              
     echo -n ${GPROMPT}                                                                
   }                                                                                   
}
function set_prompt () {
     export PS1="$(git_prompt)\[$(tput bold)\]\[\033[38;5;1m\][\[$(tput sgr0)\]\[\033[38;5;2m\]\u\[$(tput sgr0)\]\[\033[38;5;1m\]@\[$(tput sgr0)\]\[\033[38;5;5m\]\H\[$(tput sgr0)\]\[\033[38;5;1m\]][\[$(tput sgr0)\]\[\033[38;5;15m\]\w\[$(tput sgr0)\]\[\033[38;5;1m\]]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "
}

PROMPT_COMMAND="set_prompt" 

# ========================================================================= #

# ===================== Screen runner ===================================== #
function runScreen (){
if [ ! $PARENT ] ; then export PARENT=$$ ; fi 
if [[ -z $(pstree -lp | grep screen | grep "$PARENT") ]]  ;  then screen  ; fi
}

# =============== My start bash scripts (runScreen only for now :) ======== #
# runScreen;
# ========================================================================= #

# =============== A nice way to find process -> swap usage ================ #
# for dir in $(ls | grep -o '[0-9]*') ; do awk '/VmSwap|Name/{printf $2 " " $3}END{print ""}' $dir/status ; done | egrep '[0-9]{4,} .B$' | sort -k 2 -n -r  | less
# ========================================================================= #


