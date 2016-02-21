#!/usr/bin/env ruby

require_relative "./tczlib.rb"

OPTS = ARGV.select{|a|a.start_with?("-")}
COMMANDS = ARGV.select{|a|!a.start_with?("-")}

if !COMMANDS.empty?
  if COMMANDS[0] == "clean"
    exec_wrap("rm -rf ${OUTPUT_DIR}/*")
  elsif COMMANDS[0] == "allclean"
    exec_wrap("rm -rf ${DISTFILES}/*")
    exec_wrap("rm -rf ${REPOSITORY}/*")
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

buildpack
