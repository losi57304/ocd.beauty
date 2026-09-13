alias dec := decrypt
alias enc := encrypt

set default-list := true

@decrypt:
    sops decrypt .enc.env >.env

@deploy:
    git pull

    just decrypt

    docker compose pull
    docker compose up -d --remove-orphans

@encrypt:
    sops encrypt .env >.enc.env
