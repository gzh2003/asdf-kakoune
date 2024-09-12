#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/mawww/kakoune"
TOOL_NAME="kakoune"
TOOL_TEST="kak -version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kakoune is not hosted on GitHub releases.
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
	list_github_tags |
		# Filter for YYYY.MM.DD versions
		grep -E '^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$'
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$GH_REPO/archive/v${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# Search for the path to Makefile in $install_path
		local path_to_makefile
		path_to_makefile=$(find "$install_path" -name "Makefile" | head -n 1)

		if [ -z "$path_to_makefile" ]; then
			fail "Makefile not found in $install_path"
		fi

		# Run make in the directory containing the Makefile
		local makefile_dir
		makefile_dir=$(dirname "$path_to_makefile")

		# Force build to use GCC 10 in order to compile sources 2020.09.01 and earlier
		if dpkg --compare-versions "$version" le "2020.09.01"; then
			CC=gcc-10 CXX=g++-10 make -C "$makefile_dir"
		else
			make -C "$makefile_dir"
		fi

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/src/$tool_cmd" || fail "Expected $install_path/src/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
