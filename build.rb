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

buildpkg "mypkgs/9p"
buildpkg "mypkgs/b43"

buildpkg "mypkgs/dwm"
buildpkg "mypkgs/dmenu"
buildpkg "mypkgs/zsh"
buildpkg "mypkgs/RictyDiminished"
buildpkg "mypkgs/myconfig"
buildpkg "mypkgs/vim"
buildpkg "mypkgs/im/ecm-dev"
buildpkg "mypkgs/im/ecm"

buildpkg "mypkgs/im/ibus"
buildpkg "mypkgs/im/ibus-dev"
# broken!
#buildpkg "mypkgs/im/ibus-anthy" # depends ibus-dev and anthy-dev

buildpkg "mypkgs/im/scim"
buildpkg "mypkgs/im/scim-dev"
buildpkg "mypkgs/im/scim-anthy" # depends ibus-dev and anthy-dev

buildpkg "mypkgs/im/yaskkserv"

buildpack
