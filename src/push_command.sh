if [[ -n "${args[--all]}" ]]; then
  local exit_code
  local -A results=()
  for f in migrates/*.tfstate ; do
    set +e
    push_tfstate "$f" "${args[--force]}" "${args[--ignore-remote-version]}"
    exit_code="$?"
    set -e
    case "$exit_code" in
      0) results[$f]="ok" ;;
      1) results[$f]="error" ;;
      2) results[$f]="error, the corresponding tfvars file is missing." ;;
      *) results[$f]="unexpected exit code."
    esac
  done
  for f in "${!results[@]}" ; do
    echo "$f : ${results[$f]}"
  done 
elif [[ -n "${args[file]}" ]] ; then
  push_tfstate "${args[file]}" "${args[--force]}" "${args[--ignore-remote-version]}"
fi

