# I probably had a repository for this that i never used...

function command_exists () { type "$1" &> /dev/null; }

# Julia
## Pluto notebook
alias pluto='julia -e "using Pluto;Pluto.run()"'


# SSH
## Renember keys
eval `ssh-agent` &> /dev/null
alias ssh-setup='eval $(ssh-agent) &> /dev/null && ssh-add'


# Windows Subsistem for Linux
## Open the Windows Terminal
function wt { powershell.exe -c "powershell.exe -c 'wt.exe -p Ubuntu -d //wsl\$/Ubuntu$(pwd)/$1'"; }
## Open a file (ex: win_open document.pdf)
function win_open { powershell.exe -c "Invoke-Item '$1'"; }
## Open the browser (ex: win_browser localhost:8000)
function win_browser { powershell.exe -c "Start https://$1"; }

# Temp fix for WSL2
fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}


## SSH
### Remember keys
# alias ssh-setup='eval $(ssh-agent) &> /dev/null && ssh-add'
function ssh-setup {
    RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
    if [ -z "$SSH_AUTH_SOCK" ]; then
        # Check for a currently running instance of the agent
        RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
        if [ "$RUNNING_AGENT" = "0" ]; then
            # Launch a new instance of the agent
            ssh-agent -s &> $HOME/.ssh/ssh-agent
        fi
        eval `cat $HOME/.ssh/ssh-agent`
    fi
    ssh-add
}
