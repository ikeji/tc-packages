#!/usr/bin/env ruby

require_relative "./tczlib.rb"

OPTS = ARGV.select{|a|a.start_with?("-")}
COMMANDS = ARGV.select{|a|!a.start_with?("-")}

if !COMMANDS.empty?
  if COMMANDS[0] == "clean"
    exec_wrap("rm -rf #{OUTPUT_DIR}/*")
  elsif COMMANDS[0] == "allclean"
    exec_wrap("rm -rf #{DISTFILES}/*")
    exec_wrap("rm -rf #{REPOSITORY}/*")
  elsif COMMANDS[0] == "pack"
    buildpack
  else
    buildpkg ARGV[0].gsub(/\.pkg$/,"")
  end
  exit
end

buildpkg "mypkgs/gnupg/pth"
buildpkg "mypkgs/gnupg/pth-dev"

buildpkg "mypkgs/gnupg/pcsc-lite"
buildpkg "mypkgs/gnupg/pcsc-lite-dev"
buildpkg "mypkgs/gnupg/ccid" # depends pcsc-lite-dev

buildpkg "mypkgs/gnupg/libgpg-error"
buildpkg "mypkgs/gnupg/libgpg-error-dev"
buildpkg "mypkgs/gnupg/gnupg" # depends libgpg-error
buildpkg "mypkgs/gnupg/pinentry" # depends libgpg-error

buildpkg "mypkgs/zsh"

buildpkg "mypkgs/ocaml"
buildpkg "mypkgs/unison"

buildpkg "mypkgs/im/anthy"
buildpkg "mypkgs/im/anthy-dev"

buildpkg "mypkgs/im/extra-cmake-modules"

buildpkg "mypkgs/im/libxcb"
buildpkg "mypkgs/im/libxcb-dev"

buildpkg "mypkgs/im/xkbcommon-dev" # depends libxcb-dev
buildpkg "mypkgs/im/xkbcommon" # depends libxcb-dev

buildpkg "mypkgs/im/fcitx" # depends xkbcommon-dev
buildpkg "mypkgs/im/fcitx-dev" # depends xkbcommon-dev

buildpkg "mypkgs/im/fcitx-anthy" # depends fcitx-dev anthy-dev

buildpkg "mypkgs/im/skkinput2"
buildpkg "mypkgs/im/skkinput3"

buildpack
