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

    sops --decrypt --input-type binary --output-type binary stacks/ingress/rathole-config.enc.json > stacks/ingress/rathole-config.toml

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

    sops --encrypt --input-type binary --output-type binary stacks/ingress/rathole-config.toml > stacks/ingress/rathole-config.enc.json
