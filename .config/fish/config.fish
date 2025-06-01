#  ____ _____
# |  _ \_   _|  Derek Taylor (DistroTube)
# | | | || |    http://www.youtube.com/c/DistroTube
# | |_| || |    http://www.gitlab.com/dwt1/
# |____/ |_|
#
# My fish config. Not much to see here; just some pretty standard stuff.

### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $HOME/.emacs.d/bin $HOME/Applications /var/lib/flatpak/exports/bin/ /home/linuxbrew/.linuxbrew/bin/ $HOME/cargo/bin $fish_user_paths /opt/cni/bin $HOME/istio-1.19.0/bin

### SET MANPAGER
### Uncomment only one of these!

### "bat" as manpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

### "vim" as manpager
# set -x MANPAGER '/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

### "nvim" as manpager
# set -x MANPAGER "nvim -c 'set ft=man' -"

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
    #fish_vi_key_bindings
    fish_default_key_bindings
end

### END OF VI MODE ###
# Bind control + F for auto suggestion
bind -M insert \cf accept-autosuggestion

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

### SPARK ###
set -g spark_version 1.0.0

complete -xc spark -n __fish_use_subcommand -a --help -d "Show usage help"
complete -xc spark -n __fish_use_subcommand -a --version -d "$spark_version"
complete -xc spark -n __fish_use_subcommand -a --min -d "Minimum range value"
complete -xc spark -n __fish_use_subcommand -a --max -d "Maximum range value"

function spark -d "sparkline generator"
    if isatty
        switch "$argv"
            case {,-}-v{ersion,}
                echo "spark version $spark_version"
            case {,-}-h{elp,}
                echo "usage: spark [--min=<n> --max=<n>] <numbers...>  Draw sparklines"
                echo "examples:"
                echo "       spark 1 2 3 4"
                echo "       seq 100 | sort -R | spark"
                echo "       awk \\\$0=length spark.fish | spark"
            case \*
                echo $argv | spark $argv
        end
        return
    end

    command awk -v FS="[[:space:],]*" -v argv="$argv" '
        BEGIN {
            min = match(argv, /--min=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
            max = match(argv, /--max=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
        }
        {
            for (i = j = 1; i <= NF; i++) {
                if ($i ~ /^--/) continue
                if ($i !~ /^-?[0-9]/) data[count + j++] = ""
                else {
                    v = data[count + j++] = int($i)
                    if (max == "" && min == "") max = min = v
                    if (max < v) max = v
                    if (min > v ) min = v
                }
            }
            count += j - 1
        }
        END {
            n = split(min == max && max ? "▅ ▅" : "▁ ▂ ▃ ▄ ▅ ▆ ▇ █", blocks, " ")
            scale = (scale = int(256 * (max - min) / (n - 1))) ? scale : 1
            for (i = 1; i <= count; i++)
                out = out (data[i] == "" ? " " : blocks[idx = int(256 * (data[i] - min) / scale) + 1])
            print out
        }
    '
end
### END OF SPARK ###

### FUNCTIONS ###

# Functions needed for !! and !$
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end
# The bindings for !! and !$
if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Function for printing a column (splits input on whitespace)
# ex: echo 1 2 3 | coln 3
# output: 3
function coln
    while read -l input
        echo $input | awk '{print $'$argv[1]'}'
    end
end

# Function for printing a row
# ex: seq 3 | rown 3
# output: 3
function rown --argument index
    sed -n "$index p"
end

# Function for ignoring the first 'n' lines
# ex: seq 10 | skip 5
# results: prints everything but the first 5 lines
function skip --argument n
    tail +(math 1 + $n)
end

# Function for taking the first 'n' lines
# ex: seq 10 | take 5
# results: prints only the first 5 lines
function take --argument number
    head -$number
end

# Function for org-agenda
function org-search -d "send a search string to org-mode"
    set -l output (/usr/bin/emacsclient -a "" -e "(message \"%s\" (mapconcat #'substring-no-properties \
        (mapcar #'org-link-display-format \
        (org-ql-query \
        :select #'org-get-heading \
        :from  (org-agenda-files) \
        :where (org-ql--query-string-to-sexp \"$argv\"))) \
        \"
    \"))")
    printf $output
end

### END OF FUNCTIONS ###

### ALIASES ###
# vim and emacs
alias vim='nvim'
alias em='/usr/bin/emacs -nw'
alias emacs="emacsclient -c -a 'emacs'"

# Changing "ls" to "exa"
alias ls='/opt/homebrew/bin/eza -al --color=always --group-directories-first' # my preferred listing
alias la='/opt/homebrew/bin/eza -a --color=always --group-directories-first' # all files and dirs
alias ll='/opt/homebrew/bin/eza -l --color=always --group-directories-first' # long format
alias lt='/opt/homebrew/bin/eza -aT --color=always --group-directories-first' # tree listing
alias l.='/opt/homebrew/bin/eza -a | egrep "^\."'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias vifm='./.config/vifm/scripts/vifmrun'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# git
alias g="git"
alias gbr="git branch -a"
alias gst="git status"
alias gcp="git add . && git commit --amend --no-edit && git push -f"
alias grc="git rebase --continue"
alias grs="git rebase --skip"
alias grhh="git reset --hard HEAD"
set bashrc HOME/.bashrc
[ -f "$bashrc" ] && source "$bashrc"
# nvm use lts

alias tri="terraform init"
alias trp="terraform plan"
alias trv="terraform validate"
alias tra="terraform apply --auto-approve"
alias trd="terraform apply -destroy --auto-approve"
alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm ghcr.io/laniksj/dfimage"
alias vim="nvim"
alias dcd="docker compose down"
alias dcu="docker compose up -d"
alias dcb="docker compose build"
alias dcr="docker compose down && docker compose up -d"

# Kubernetes CLI
alias k="kubectl"
alias kgn="kubectl get node"
alias kgp="kubectl get pod"
alias kgpo="k get po -owide "
alias kgn="k get node "
alias kgs="k get svc "
alias kn="kubectl config set-context --current --namespace "
alias kr="k run --dry-run=client -oyaml --image "
alias ka="k apply -f "
alias krep="k replace --force -f "
export do="--dry-run=client -oyaml "

# Kubenetes with Minikube
alias mk="minikube kubectl --"

# Vagrant for WSL
set VAGRANT_WSL_ENABLE_WINDOWS_ACCESS 1

function ahp
    echo $argv | sed 's/ /-/g'
end

function sphinxb
    docker run --rm -u 1000 -v $(pwd):/sphinxneeds artifactory.boschdevcloud.com/docs-as-code-docker-local/sphinxneeds-toolkit:0.0.9 sphinx-build -b singlehtml $argv[1] $argv[2]
end
# set M2_HOME "/opt/apache-maven-3.8.6"
# set PATH "$PATH:/home/deww/.local/bin/"
set GOROOT /home/deww/Repos/goroot/
set GOPATH /home/deww/go/bin/

### SETTING THE STARSHIP PROMPT ###

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/deww/.lmstudio/bin
# End of LM Studio CLI section

