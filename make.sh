#!/bin/bash
set -eu

# Check if jq is present
if ! [ -x "$(command -v go 2>/dev/null)" ]; then
    echo 'error: go is requiered.' 1>&2
    exit 2
fi

function build {
    os=$1
    arch=$2
    target="foo"
    ext=$(echo "$([ "$os" = "windows" ] && echo ".exe")")

    printf "\n\e[92m[$os/$arch]\e[0m\n"
    env GOOS=$os GOARCH=$arch go build -v -o "bin/${target}_${os}_${arch}${ext}" "src/foo.go"
}

printf "\e[42m--- Build ---\e[0m\n"

arch="amd64"
build darwin $arch
build freebsd $arch
build linux $arch
build openbsd $arch
build solaris $arch
build windows $arch

arch="386"
build freebsd $arch
build linux $arch
build openbsd $arch
build windows $arch

arch="arm"
build linux $arch

printf "\n\n\e[42m--- Pack ---\e[0m\n\n"
bsdtar acvf dist/foo.zip bin/*

printf "\n\n\e[42m--- Done ---\e[0m\n"
