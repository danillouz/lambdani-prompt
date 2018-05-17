__exists() {
  command -v $1 > /dev/null 2>&1
}

_git_branch() {
  local _ref

  _ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  _ref=$(command git rev-parse --short HEAD 2> /dev/null) || return

  echo "${_ref#refs/heads/}"
}

_git_status() {
  local _status=""
  local _index=$(command git status --porcelain 2> /dev/null)
  local _staged="%{$reset_color%}%{$fg[green]%}●%{$reset_color%}"
  local _unstaged="%{$reset_color%}%{$fg[magenta]%}●%{$reset_color%}"
  local _untracked="%{$reset_color%}%{$fg[yellow]%}●%{$reset_color%}"
  local _unmerged="%{$reset_color%}%{$fg[red]%}\u26A1%{$reset_color%}"
  local _ahead="%{$reset_color%}%{$fg[green]%}\u25B2%{$reset_color%}"
  local _behind="%{$reset_color%}%{$fg[red]%}\u25BC%{$reset_color%}"
  local _diverged="%{$reset_color%}%{$fg[red]%}\uE0A0%{$reset_color%}"
  local _stashed="%{$reset_color%}%{$fg[yellow]%}\uF187%{$reset_color%}"

  if [[ -n "$_index" ]]; then
    if $(echo "$_index" | command grep -q '^[AMRD]. '); then
      _status="$_status$_staged"
    fi

    if $(echo "$_index" | command grep -q '^.[MTD] '); then
      _status="$_status$_unstaged"
    fi

    if $(echo "$_index" | command grep -q -E '^\?\? '); then
      _status="$_status$_untracked"
    fi

    if $(echo "$_index" | command grep -q '^UU '); then
      _status="$_status$_unmerged"
    fi
  fi

  _index=$(command git status --porcelain -b 2> /dev/null)

  if $(echo "$_index" | command grep -q '^## .*ahead'); then
    _status="$_status$_ahead"
  fi

  if $(echo "$_index" | command grep -q '^## .*behind'); then
    _status="$_status$_behind"
  fi

  if $(echo "$_index" | command grep -q '^## .*diverged'); then
    _status="$_status$_diverged"
  fi

  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    _status="$_status$_stashed"
  fi

  echo $_status
}

_git_prompt() {
  local _branch=$(_git_branch)
  local _status=$(_git_status)
  local _result=""

  if [[ "${_branch}x" != "x" ]]; then
    _result="%{$fg[$LAMBDANI_GIT_BRANCH_COLOR]%}$_branch%{$reset_color%}"

    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi

    _result="\uF126 $_result "
  fi

  echo $_result
}

_work_dir() {
  echo "\uE5FF %{$fg[$LAMBDANI_WD_COLOR]%}%~%{$reset_color%}"
}

_k8s() {
  if __exists kube_ps1; then
    echo "$(kube_ps1)"
  fi
}

_aws() {
  if __exists aws; then
    echo "\uF6A5 $AWS_DEFAULT_PROFILE"
  fi
}

_separator() {
  local color

  if [[ $RETVAL -eq 0 ]]; then
    color="%{$reset_color%}"
  else
    color="red"
  fi

  echo "%{$fg[$color]%}λ%{$reset_color%}"
}

_prompt() {
  RETVAL=$?

  echo "\\n$(_work_dir) $(_git_prompt)$(_separator) "
}

_r_prompt() {
  echo "$(_k8s) $(_aws)"
}

# brew install kube-ps1
# see https://github.com/jonmosco/kube-ps1
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
KUBE_PS1_PREFIX=""
KUBE_PS1_SEPARATOR=""
KUBE_PS1_SUFFIX=""
KUBE_PS1_SYMBOL_COLOR="%{$reset_color%}"

LAMBDANI_WD_COLOR="${LAMBDANI_WD_COLOR=blue}"
LAMBDANI_GIT_BRANCH_COLOR="${LAMBDANI_GIT_BRANCH_COLOR=cyan}"

PROMPT='$(_prompt)'
RPROMPT='$(_r_prompt)'