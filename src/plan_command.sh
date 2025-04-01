if [[ -n "${args[--all]}" ]]; then
  for f in envs/*.tfvars ; do
    plan_tfvars "$f" "${args[--destroy]}" "${args[--refresh-only]}" || true
  done
elif [[ -n "${args[file]}" ]]; then
  plan_tfvars "${args[file]}" "${args[--destroy]}" "${args[--refresh-only]}"
fi

