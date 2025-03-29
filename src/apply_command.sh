if [[ -n "${args[--all]}" ]]; then
  for f in envs/*.tfvars ; do
    apply_tfvars "$f" "${args[--destroy]}"
  done
elif [[ -n "${args[--plan-all]}" ]]; then
  for f in plans/*.tfplan ; do
    apply_tfplan "$f"
  done
elif [[ -n "${args[file]}" ]]; then
  case "${args[file]}" in
    envs/*)  apply_tfvars "${args[file]}" "${args[--destroy]}" ;;
    plans/*) apply_tfplan "${args[file]}" ;;
  esac
fi

