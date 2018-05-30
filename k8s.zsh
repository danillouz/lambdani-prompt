# brew install kube-ps1
# see https://github.com/jonmosco/kube-ps1
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"

KUBE_PS1_PREFIX=""
KUBE_PS1_SYMBOL_DEFAULT=""
KUBE_PS1_SEPARATOR="k8s:"
KUBE_PS1_DIVIDER="."
KUBE_PS1_SUFFIX=""
KUBE_PS1_CTX_COLOR="yellow"
KUBE_PS1_NS_COLOR="cyan"

lambdani_k8s() {
  if lambdani_exists kube_ps1; then
    echo "$(kube_ps1)"
  fi
}