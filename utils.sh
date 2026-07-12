repeat_char() {
  local char="$1"
  local count="$2"

  for ((i = 0; i < count; i++)); do
    printf '%s' "$char"
  done
  printf '\n'
}

print_switch_header() {
  local command="$1"
  local name="$2"
  local mode="$3"

  printf "%s '%s' in '%s' mode...\n" "$command" "$name" "$mode"
  repeat_char "=" 50
}

home_switch() {
  local name="$1"
  local mode="$2"

  print_switch_header "home-switch" "$name" "$mode"
  if [[ "$mode" == "debug" ]]; then
    home-manager switch --flake ".#$name" --show-trace --verbose
  else
    home-manager switch --flake ".#$name"
  fi
}

nixos_switch() {
  local name="$1"
  local mode="$2"

  print_switch_header "nixos-switch" "$name" "$mode"
  if [[ "$mode" == "debug" ]]; then
    nom build ".#nixosConfigurations.${name}.config.system.build.toplevel" --show-trace --verbose
    nixos-rebuild switch --sudo --flake ".#$name" --show-trace --verbose
  else
    nixos-rebuild switch --sudo --flake ".#$name"
  fi
}

make_editable() {
  local path="$1"
  local tmpdir

  repeat_char "=" 50
  tmpdir="$(mktemp -d)"
  rsync -avz --copy-links "${path}/" "$tmpdir"
  rsync -avz --copy-links --chmod=D2755,F744 "${tmpdir}/" "$path"
}

darwin_build() {
  local name="$1"
  local mode="$2"
  local target=".#darwinConfigurations.${name}.system"

  print_switch_header "darwin-build" "$name" "$mode"
  if [[ "$mode" == "debug" ]]; then
    nom build "$target" --extra-experimental-features "nix-command flakes" --show-trace --verbose
  else
    nix build "$target" --extra-experimental-features "nix-command flakes"
  fi
}

darwin_switch() {
  local name="$1"
  local mode="$2"

  print_switch_header "darwin-switch" "$name" "$mode"
  if [[ "$mode" == "debug" ]]; then
    sudo -E ./result/sw/bin/darwin-rebuild switch --flake ".#$name" --show-trace --verbose
  else
    sudo -E ./result/sw/bin/darwin-rebuild switch --flake ".#$name"
  fi
}

darwin_rollback() {
  ./result/sw/bin/darwin-rebuild --rollback
}

upload_vm() {
  local name="$1"
  local mode="$2"
  local target=".#$name"
  local remote="ryan@rakushun:/data/caddy/fileserver/vms/kubevirt-${name}.qcow2"

  print_switch_header "upload-vm" "$name" "$mode"
  if [[ "$mode" == "debug" ]]; then
    nom build "$target" --show-trace
  else
    nix build "$target"
  fi

  rsync -avz --progress --copy-links --checksum result "$remote"
}
