lambdani_separator() {
  local color

  if [[ $RETVAL -eq 0 ]]; then
    color="green"
  else
    color="red"
  fi

  echo "%{$fg_bold[$color]%}λ%{$reset_color%}"
}