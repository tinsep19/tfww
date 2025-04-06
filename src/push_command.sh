local -a push_opts=()
push_opts+=("${args[--force]}")
push_opts+=("${args[--ignore-remote-version]}")

if [[ -n "${args[--all]}" ]]; then
  local exit_code
  local -A results=()
  for f in migrates/*.tfstate ; do
    # check coresponding tfvars is exists.
    if [[ -n "$(validate_tfstate "$f")" ]] ; then
      continue
    fi
  
    set +e
    push_tfstate "$f" "${push_opts[@]}"
    exit_code="$?"
    set -e

    case "$exit_code" in
      0) results["$f"]="ok" ;;
      1) results["$f"]="error" ;;
      *) results["$f"]="unexpected exit code."
    esac
  done

  for f in "${!results[@]}" ; do
    echo "$f : ${results["$f"]}"
  done 
elif [[ -n "${args[file]}" ]] ; then
  push_tfstate "${args[file]}" "${push_opts[@]}"
fi

