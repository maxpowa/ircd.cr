# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "commander"
require "../config/*"
require "../server"

cli = Commander::Command.new do |cmd|
  cmd.use = "ircd"
  cmd.long = "A minimal IRC daemon written in Crystal"

  cmd.flags.add do |flag|
    flag.name = "verbose"
    flag.short = "-v"
    flag.long = "--verbose"
    flag.default = false
    flag.description = "Enable more verbose logging."
  end

  cmd.flags.add do |flag|
    flag.name = "config"
    flag.short = "-c"
    flag.long = "--config"
    flag.default = "~/.ircd.cr.yml"
    flag.description = "Path to config.yml"
  end

  cmd.run do |options, arguments|
    config_path = File.expand_path(options.string["config"]) # => "~/.ircd.cr.yml"

    config = IRCd::Config::Mapping.load(config_path)
    config.verbose = options.bool["verbose"] || config.verbose

    server = IRCd::Server.new config

    puts server.inspect
  end
end

Commander.run(cli, ARGV)
