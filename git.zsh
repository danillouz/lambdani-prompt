LAMBDANI_GIT_BRANCH_COLOR="${LAMBDANI_GIT_BRANCH_COLOR=cyan}"

_lambdani_git_branch() {
  local _ref

  _ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  _ref=$(command git rev-parse --short HEAD 2> /dev/null) || return

  echo "${_ref#refs/heads/}"
}

_lambdani_git_status() {
  local _status=""
  local _index=$(command git status --porcelain 2> /dev/null)
  local _staged="%{$reset_color%}%{$fg[green]%}●%{$reset_color%}"
  local _unstaged="%{$reset_color%}%{$fg[magenta]%}●%{$reset_color%}"
  local _untracked="%{$reset_color%}%{$fg[yellow]%}●%{$reset_color%}"
  local _unmerged="%{$reset_color%}%{$fg[red]%}✖︎%{$reset_color%}"
  local _ahead="%{$reset_color%}%{$fg[green]%}▲%{$reset_color%}"
  local _behind="%{$reset_color%}%{$fg[red]%}▼%{$reset_color%}"
  local _diverged="%{$reset_color%}%{$fg[red]%}❖%{$reset_color%}"
  local _stashed="%{$reset_color%}%{$fg[yellow]%}❒%{$reset_color%}"

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

lambdani_git_prompt() {
  local _branch=$(_lambdani_git_branch)
  local _status=$(_lambdani_git_status)
  local _result=""

  if [[ "${_branch}x" != "x" ]]; then
    _result="%{$fg[$LAMBDANI_GIT_BRANCH_COLOR]%}$_branch%{$reset_color%}"

    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi

    _result="git:$_result "
  fi

  echo $_result
}