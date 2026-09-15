alias dec := decrypt
alias enc := encrypt

@decrypt:
    sops decrypt .enc.env >.env

@deploy:
    docker compose down

    git pull

    just decrypt

    docker compose up -d

@encrypt:
    sops encrypt .env >.enc.env
