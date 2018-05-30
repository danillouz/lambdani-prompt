local lambdani_dir="${0%/*}"

source "$lambdani_dir/lambdani-prompt/utils.zsh"
source "$lambdani_dir/lambdani-prompt/workdir.zsh"
source "$lambdani_dir/lambdani-prompt/git.zsh"
source "$lambdani_dir/lambdani-prompt/separator.zsh"
source "$lambdani_dir/lambdani-prompt/k8s.zsh"

_lambdani_dir_prompt() {
  RETVAL=$?

  echo "\\n$(lambdani_work_dir) $(lambdani_git_prompt)\\n$(lambdani_separator) "
}

_lambdani_dir_r_prompt() {
  echo "$(lambdani_k8s)"
}

PROMPT='$(_lambdani_dir_prompt)'
RPROMPT='$(_lambdani_dir_r_prompt)'