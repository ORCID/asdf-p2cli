#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/wrouesnel/p2cli"
TOOL_NAME="p2"
TOOL_TEST="p2 --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

list_all_versions() {
  list_github_tags
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^r//'
}

sort_versions() {
  sort -n
  # sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
  #  LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local platform
  case "$(uname)" in
  Linux) platform=linux ;;
  Darwin) platform=darwin ;;
  FreeBSD) platform=freebsd ;;
  *) platform=windows ;;
  esac

  local arch
  case "$(uname -m)" in
  x86_64) arch=amd64 ;;
  amd64) arch=amd64 ;;
  x86) arch=386 ;;
  aarch64 | arm64) arch=arm64 ;;
  esac

  url="$GH_REPO/releases/download/r${version}/p2cli_r${version}_${platform}-${arch}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3/bin"

  local platform
  case "$(uname)" in
  Linux) platform=linux ;;
  Darwin) platform=darwin ;;
  FreeBSD) platform=freebsd ;;
  *) platform=windows ;;
  esac

  local arch
  case "$(uname -m)" in
  x86_64) arch=amd64 ;;
  amd64) arch=amd64 ;;
  x86) arch=386 ;;
  aarch64 | arm64) arch=arm64 ;;
  esac

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/p2cli_r${version}_${platform}-${arch}/$tool_cmd "$install_path/$tool_cmd"

    chmod +x "$install_path/$tool_cmd"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful in $install_path!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
