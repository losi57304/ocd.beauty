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

    sops decrypt "stacks/auth/config/users_database.enc.yml" > "stacks/auth/config/users_database.yml"

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

    sops encrypt "stacks/auth/config/users_database.yml" > "stacks/auth/config/users_database.enc.yml"
