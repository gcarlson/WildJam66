#!/bin/sh
echo -ne '\033c\033]0;Wild Jam 66\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/heat_rises_linux.x86_64" "$@"
