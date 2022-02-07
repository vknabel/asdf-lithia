#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/vknabel/lithia"
TOOL_NAME="lithia"
TOOL_TEST="lithia --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if lithia is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  ostype=""
  case "$OSTYPE" in
    darwin*)  ostype="Darwin" ;;
    linux*)   ostype="Linux" ;;
    msys*)    ostype="Windows" ;;
    cygwin*)  ostype="Window" ;;
    *)        ostype="Linux" ;; #probably linux
  esac

  architecture=""
  case $(uname -m) in
      i686)   architecture="x86_64" ;;
      x86_64) architecture="x86_64" ;;
      arm)    dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
      *)      architecture="x86_64" ;;
  esac

  url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_${ostype}_${architecture}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (

    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH/" "$install_path"
    mkdir "$install_path/bin"
    mv "$ASDF_DOWNLOAD_PATH/$TOOL_NAME" "$install_path/bin/$TOOL_NAME"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
