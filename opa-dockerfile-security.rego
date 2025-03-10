package main

# Do Not store secrets in ENV variables
secrets_env := {
    "passwd",
    "password",
    "pass",
    "secret",
    "key",
    "access",
    "api_key",
    "apikey",
    "token",
    "tkn"
}

deny[msg] {    
    some i
    input[i].Cmd == "env"
    val := input[i].Value
    some s in secrets_env
    contains(lower(val[_]), s)
    msg := sprintf("Line %d: Potential secret in ENV key found: %s", [i, val])
}

# Do not use 'latest' tag for base images
deny[msg] {
    some i
    input[i].Cmd == "from"
    val := split(input[i].Value[0], ":")
    count(val) > 1
    lower(val[1]) == "latest"
    msg := sprintf("Line %d: Do not use 'latest' tag for base images", [i])
}

# Do not use ADD if possible
deny[msg] {
    some i
    input[i].Cmd == "add"
    msg := sprintf("Line %d: Use COPY instead of ADD", [i])
}

# Ensure USER is specified
any_user {
    some i
    input[i].Cmd == "user"
}

deny[msg] {
    not any_user
    msg := "Do not run as root, use USER instead"
}

# Do not use forbidden users
forbidden_users := {
    "root",
    "toor",
    "0"
}

deny[msg] {
    some i
    input[i].Cmd == "user"
    users := [name | some j; input[j].Cmd == "user"; name := input[j].Value]
    lastuser := users[count(users) - 1]
    some u in forbidden_users
    contains(lower(lastuser), u)
    msg := sprintf("Line %d: Last USER directive (USER %s) is forbidden", [i, lastuser])
}

# Do not use sudo
deny[msg] {
    some i
    input[i].Cmd == "run"
    val := concat(" ", input[i].Value)
    contains(lower(val), "sudo")
    msg := sprintf("Line %d: Do not use 'sudo' command", [i])
}
