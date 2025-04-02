if [[ -n "${args[--all]}" ]]; then
  local exit_code
  local -A results=()
  for f in envs/*.tfvars ; do
    set +e
    plan_tfvars "$f" "${args[--destroy]}" "${args[--refresh-only]}"
    exit_code="$?"
    case "$exit_code" in
      0) results[$f]="ok" ;;
      1) results[$f]="error" ;;
      2) results[$f]="ok (no changes)" ;;
    esac
    set -e
  done
  for f in "${!results[@]}" ; do
    echo "$f : ${results[$f]}"
  done 
elif [[ -n "${args[file]}" ]]; then
  plan_tfvars "${args[file]}" "${args[--destroy]}" "${args[--refresh-only]}"
fi

