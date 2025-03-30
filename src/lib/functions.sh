validate_tfvars_or_tfplan () {
  if [[ "$1" == plans/*.tfplan ]]; then
    [[ -f "$1" ]] || echo "must be an existing file."
  elif [[ "$1" ==  envs/*.tfvars ]]; then
    [[ -f "$1" ]] || echo "must be an existing file."
  else
    echo "must be envs/*.tfvars or plans/*.tfplan"
  fi
}

validate_tfvars () {
  if [[ "$1" ==  envs/*.tfvars ]]; then
    [[ -f "$1" ]] || echo "must be an existing file."
  else
    echo "must be envs/*.tfvars"
  fi
}

extract_workspace () {
  if [[ "$1" == plans/*.tfplan ]]; then
    echo "$(basename "$1" ".tfplan")"
  elif [[ "$1" == envs/*.tfvars ]]; then
    echo "$(basename "$1" ".tfvars")"
  fi
}

switch_or_create_workspace () {
  terraform workspace select "$1" 2>/dev/null || terraform workspace new "$1"
}

switch_tfvars_or_tfplan () {
  local ws="$(extract_workspace "$1")"
  switch_or_create_workspace "$ws"
}

plan_tfvars () {
  local ws="$(extract_workspace "$1")"
  switch_tfvars_or_tfplan "$1"
  
  local -a plan_opts=()
  plan_opts+=(-var-file=$1)
  plan_opts+=(-out=plans/$ws.tfplan)
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
  switch_tfvars_or_tfplan "$1"
  local -a apply_opts=()
  apply_opts+=(-var-file=$1)
  apply_opts+=(-compact-warnings)
  apply_opts+=(-input=false)

  if [[ -n "$2" ]]; then
    apply_opts+=(-destroy)
  fi
  terraform apply "${apply_opts[@]}"
}

apply_tfplan () {
  switch_tfvars_or_tfplan "$1"
  terraform apply "$1"
}

show_current_state () {
  switch_tfvars_or_tfplan "$1"
  local -a show_opts=()
  if [[ -n "$2" ]]; then
    show_opts+=(-json)
  fi
  terraform show "${show_opts[@]}"
}

show_tfplan () {
  switch_tfvars_or_tfplan "$1"
  local -a show_opts=()
  if [[ -n "$2" ]]; then
    show_opts+=(-json)
  fi
  show_opts+=($1)
  terraform show "${show_opts[@]}"
}
