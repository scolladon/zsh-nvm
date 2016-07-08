if [ -z "$NVM_DIR" ]; then
  NVM_DIR="$HOME/.nvm"
fi

_zsh_nvm_has() {
  type "$1" > /dev/null 2>&1
}

_zsh_nvm_get() {
  if _zsh_nvm_has "curl"; then
    curl --silent "$1"
  elif _zsh_nvm_has "wget"; then
    wget --quiet --output-document - "$1"
  fi
}

_zsh_nvm_latest_release_tag() {
  _zsh_nvm_get "https://api.github.com/repos/creationix/nvm/releases/latest" |  # Get latest release from GitHub api
    grep '"tag_name":' |                                                        # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                                # Pluck JSON value
}

_zsh_nvm_install() {
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout --quiet "$(_zsh_nvm_latest_release_tag)"
}

nvm_update() {
  echo "Checking latest version of nvm..."
  local latest_version=$(_zsh_nvm_latest_release_tag)
  echo "Latest version is $latest_version"
  echo "Fetching updates..."
  cd "$NVM_DIR"
  git fetch
  git checkout "$latest_version"
}

# Install nvm if it isn't already installed
[[ ! -f "$NVM_DIR/nvm.sh" ]] && _zsh_nvm_install

# If nvm is installed, source it
[[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
