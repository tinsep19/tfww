if [[ -n "${args[--all]}" ]]; then
  for f in envs/*.tfvars ; do
    plan_tfvars "$f" "${args[--destroy]}"
  done
elif [[ -n "${args[file]}" ]]; then
  plan_tfvars "${args[file]}" "${args[--destroy]}"
fi

