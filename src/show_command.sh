case "${args[file]}" in
  envs/*)  show_current_state "${args[file]}" "${args[--json]}" ;;
  plans/*) show_tfplan "${args[file]}" "${args[--json]}" ;;
esac

