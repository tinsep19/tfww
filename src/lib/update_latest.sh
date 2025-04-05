update_latest () {
  local repo="repos/tinsep19/tfww"
  local release_url="https://api.github.com/$repo/releases/latest"
  local release_json="$(curl -s "$release_url")"
  
  local src="${BASH_SOURCE[0]}"
  local self_path
  local tmp_dir

  self_path="$(cd -- $(dirname -- "$src") && pwd -P)/$(basename "$src")"

  local query='.assets[0] | select(.name == "tfww") | .browser_download_url'
  local tfww_url
  local latest_version

  tfww_url="$(jq "$query" -r <<<"$release_json")"
  latest_version="$(jq .name -r <<<"$release_json")"
  echo "$latest_version is found."
    
  tmp_dir="$(mktemp -d)"

  echo "Download from $tfww_url -> $tmp_dir/tfww"
  curl -o "$tmp_dir/tfww" -s -L "$tfww_url"
  chmod +x "$tmp_dir/tfww"
  echo "update $self_path force"
  rm "$self_path" && mv "$tmp_dir/tfww" "$self_path"
}
