if status is-interactive
    nvm use lts
    alias vim=nvim
    alias lsa="ls -la"
    alias gst="git status"
    alias gbr="git branch --all"
    alias gcp="git add . && git commit --amend && git push -f"
    alias dcd="docker compose down"
    alias dcu="docker compose up"
    alias dcdu="docker compose up -d --build"
    alias dcr="dcd && dcu"
    alias k="kubectl"
    alias g="git"

    # Terraform Commands
    alias tra="terraform apply --auto-approve"
    alias trd="terraform destroy --auto-approve"

    # Commands to run in interactive sessions can go here
    fish_add_path /Users/deww/tools/flutter/bin
    set -x DOCKER_BUILDKIT 0
    set -x COMPOSE_DOCKER_CLI_BUILD 0
    set -x GOROOT /opt/homebrew/Cellar/go/1.23.4/libexec/
    set -x GOPATH /Users/deww/.golib
    set -x GOHOME /Users/deww/Desktop/Repos/golang/gohome
    set -x PUBLIC_KEY /Users/deww/tools/sealsecret/pub_cert.pem
    set -x DOCKER_DEFAULT_PLATFORM linux/amd64

    fish_add_path /Users/deww/.golib/bin /Users/deww/Library/Python/3.9/bin

    # Kubernetes
    alias kgp="kubectl get po "
    alias kgn="kubectl get node "
    alias kgs="kubectl get svc "
    alias kgpo="kubectl get po --owide "
    alias kn="kubectl config set-context --current --namespace "
    alias ka="kubectl apply -f "
    alias krep="kubectl replace --force -f "
    alias kgd="kubectl get deploy "
    alias kr="kubectl run --dry-run=client -oyaml --image "

end
