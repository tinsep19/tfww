validate_tfvars () {
  case "$1" in
    envs/*.tfvars) [[ -f "$1" ]] || echo "must be an existing file." ;;
    *) echo "must be envs/*.tfvars" ;;
  esac
}

validate_tfvars_or_tfplan () {
  local ws
  case "$1" in
    envs/*.tfvars)  ws="$(basename "$1" ".tfvars")" ;;
    plans/*.tfplan) ws="$(basename "$1" ".tfplan")" ;;
    *)
      echo "must be envs/*.tfvars or plans/*.tfplan"
      return 0
    ;;
  esac
  if [[ ! -f "$1" ]]; then
    echo "must be an existing file."
  elif [[ ! -f "envs/$ws.tfvars" ]] ; then
    echo "corresponding $ws.tfvars file is missing."
  fi
}

validate_tfstate () {
  local ws
  case "$1" in
    migrates/*.tfstate) ws="$(basename "$1" ".tfstate")" ;;
    *)
      echo "must be migrates/*.tfstate"
      return 0
    ;;
  esac
  if [[ ! -f "$1" ]] ; then
    echo "must be an existing file."
  elif [[ ! -f "envs/$ws.tfvars" ]] ; then
    echo "corresponding $ws.tfvars file is missing."
  fi
}

switch_or_create_workspace () {
  terraform workspace select "$1" 2>/dev/null || terraform workspace new "$1"
}

switch_on () {
  local ws
  case "$1" in
    envs/*.tfvars)      ws="$(basename "$1" ".tfvars"  )"  ;;
    plans/*.tfplan)     ws="$(basename "$1" ".tfplan"  )"  ;;
    migrates/*.tfstate) ws="$(basename "$1" ".tfstate" )" ;;
    *)
    echo "unexpected file pattern." >&2
    return 100
  esac

  if [[ ! -f "envs/$ws.tfvars" ]] ; then
    echo "corresponding $ws.tfvars file is missing." >&2
    return 100
  fi
  switch_or_create_workspace "$ws"
}

plan_tfvars () {
  local ws
  local -a plan_opts=()

  ws="$(basename "$1" ".tfvars")"

  switch_on "$1" || return "$?"

  plan_opts+=(-var-file="$1")
  plan_opts+=(-out="plans/$ws.tfplan")
  plan_opts+=(-compact-warnings)
  plan_opts+=(-detailed-exitcode)
  plan_opts+=(-input=false)

  if [[ -n "$2" ]]; then
    plan_opts+=(-destroy)
  fi
  if [[ -n "$3" ]]; then
    plan_opts+=(-refresh-only)
  fi
  terraform plan "${plan_opts[@]}"
}

apply_tfvars () {
  local -a apply_opts=()
  switch_on "$1" || return "$?"

  apply_opts+=(-var-file="$1")
  apply_opts+=(-compact-warnings)
  apply_opts+=(-input=false)

  if [[ -n "$2" ]]; then apply_opts+=(-destroy) ; fi
  terraform apply "${apply_opts[@]}"
}

apply_tfplan () {
  switch_on "$1" || return "$?"
  terraform apply "$1"
}

show_current_state () {
  local -a show_opts=()
  switch_on "$1" || return "$?"
  
  if [[ -n "$2" ]]; then show_opts+=(-json) ; fi
  terraform show "${show_opts[@]}"
}

show_tfplan () {
  local -a show_opts=()
  switch_on "$1" || return "$?"

  if [[ -n "$2" ]]; then show_opts+=(-json) ; fi
  show_opts+=("$1")
  terraform show "${show_opts[@]}"
}

push_tfstate() {
  local -a push_opts=()
  switch_on "$1" || return "$?"

  if [[ -n "$2" ]]; then push_opts+=(-force) ; fi
  if [[ -n "$3" ]]; then push_opts+=(-ignore-remote-version) ; fi
  push_opts+=("$1")
  terraform state push "${push_opts[@]}"
}
