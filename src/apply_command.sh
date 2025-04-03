if [[ -n "${args[--all]}" ]]; then
  for f in envs/*.tfvars ; do
    apply_tfvars "$f" "${args[--destroy]}"
  done
elif [[ -n "${args[--plan-all]}" ]]; then
  local exit_code
  local -A results=()
  for f in plans/*.tfplan ; do
    set +e
    apply_tfplan "$f"
    exit_code="$?"
    set -e
    case "$exit_code" in
      0) results[$f]="ok" ;;
      1) results[$f]="error" ;;
      2) results[$f]="error, the corresponding tfvars file is missing." ;;
      *) results[$f]="unexpected exit code" ;;
    esac
  done
  for f in "${!results[@]}" ; do
    echo "$f : ${results[$f]}"
  done
elif [[ -n "${args[file]}" ]]; then
  case "${args[file]}" in
    envs/*)  apply_tfvars "${args[file]}" "${args[--destroy]}" ;;
    plans/*) apply_tfplan "${args[file]}" ;;
  esac
fi

