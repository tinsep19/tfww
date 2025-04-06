workspace_shoud_be () {
  local expect="$1"
  local actual="$(terraform workspace show)"
  [[ "$actual" == "$expect" ]] || fail "expect $expect but $actual"
}

cleanup () {
  rm -rf .terraform terraform.tfstate.d
  rm -f .terraform.lock.hcl
  rm -rf envs plans migrates out
}

install_terraform () {
  tfenv install
  tfenv use
}
