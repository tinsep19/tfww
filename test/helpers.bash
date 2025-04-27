workspace_shoud_be () {
  local expect="$1"
  local actual="$(terraform workspace show)"
  [[ "$actual" == "$expect" ]] || fail "expect $expect but $actual"
}
setup () {
  mkdir -p plans envs
  terraform init
  terraform workspace select default
}

teardown () {
  rm -rf envs plans .terraform terraform.tfstate.d
}

install_terraform () {
  tfenv install
  tfenv use
}
