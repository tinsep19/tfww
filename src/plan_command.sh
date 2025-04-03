if [[ -n "${args[--all]}" ]]; then
  local exit_code
  local -A results=()
  for f in envs/*.tfvars ; do
    set +e
    plan_tfvars "$f" "${args[--destroy]}" "${args[--refresh-only]}"
    exit_code="$?"
    set -e
    case "$exit_code" in
      0) results[$f]="ok" ;;
      1) results[$f]="error" ;;
      2) results[$f]="ok (no changes)" ;;
      *) results[$f]="unexpected errors"
    esac
  done
  for f in "${!results[@]}" ; do
    echo "$f : ${results[$f]}"
  done 
elif [[ -n "${args[file]}" ]]; then
  plan_tfvars "${args[file]}" "${args[--destroy]}" "${args[--refresh-only]}"
fi

