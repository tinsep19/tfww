local -a tfvars_opts=()
tfvars_opts+=("${args[--destroy]}")
tfvars_opts+=("${args[--refresh-only]}")

if [[ -n "${args[--plan-all]}" ]] ; then

  local exit_code
  local -A results=()

  for f in plans/*.tfplan ; do
    # check coresponding tfvars is exists.
    if [[ -n "$(validate_tfvars_or_tfplan "$f")" ]] ; then
      continue
    fi

    set +e
    apply_tfplan "$f"
    exit_code="$?"
    set -e

    case "$exit_code" in
      0) results[$f]="ok" ;;
      1) results[$f]="error" ;;
      *) results[$f]="unexpected exit code" ;;
    esac
  done

  for f in "${!results[@]}" ; do
    echo "$f : ${results[$f]}"
  done

elif [[ -n "${args[--all]}" ]]; then

  local exit_code
  local -A results=()

  for f in envs/*.tfvars ; do
    set +e
    apply_tfvars "$f" "${tfvars_opts[@]}"
    exit_code="$?"
    set -e

    case "$exit_code" in
      0) results["$f"]="ok" ;;
      1) results["$f"]="error" ;;
      *) results["$f"]="unexpected exit code" ;;
    esac
  done

  for f in "${!results[@]}" ; do
    echo "$f : ${results["$f"]}"
  done

elif [[ -n "${args[file]}" ]]; then

  case "${args[file]}" in
    envs/*)  apply_tfvars "${args[file]}" "${tfvars_opts[@]}";;
    plans/*) apply_tfplan "${args[file]}" ;;
  esac

fi

