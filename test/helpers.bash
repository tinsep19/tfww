workspace_shoud_be () {
  local expect="$1"
  local actual="$(terraform workspace show)"
  if [[ "$actual" == "$expect" ]] ; then
    pass "workspace is $actual"
  else
    fail "expect $expect but $actual"
  fi
}

setup () {
  describe "setup"
  mkdir -p plans envs
  terraform init >/dev/null
  terraform workspace select default >/dev/null
}

teardown () {
  describe "teardown"
  rm -rf envs plans .terraform terraform.tfstate.d >/dev/null
}

install_terraform () {
  tfenv install
  tfenv use
}
