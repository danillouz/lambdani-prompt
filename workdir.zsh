LAMBDANI_WD_COLOR="${LAMBDANI_WD_COLOR=blue}"

lambdani_work_dir() {
  echo "%{$fg[$LAMBDANI_WD_COLOR]%}%~%{$reset_color%}"
}