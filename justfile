alias dec := decrypt
alias enc := encrypt

decrypt:
    #!/bin/bash
    set -euo pipefail

    for stack in "stacks"/*; do
        if [[ -f "$stack/.enc.env" ]]; then
            sops decrypt "$stack/.enc.env" > "$stack/.env"
        fi
    done

    sops decrypt "stacks/authentication/users_database.enc.yaml" > "stacks/authentication/users_database.yaml"

deploy:
    docker compose down
    git pull
    just decrypt
    docker compose up -d

encrypt:
    #!/bin/bash
    set -euo pipefail

    for stack in "stacks"/*; do
        if [[ -f "$stack/.env" ]]; then
            sops encrypt "$stack/.env" > "$stack/.enc.env"
        fi
    done

    sops encrypt "stacks/authentication/users_database.yaml" > "stacks/authentication/users_database.enc.yaml"
