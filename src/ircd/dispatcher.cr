# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "./state"
require "./command"
require "./commands/*"

struct IRCd::Dispatcher
  property! commands : Hash(String, IRCd::Command)
  property! state : IRCd::State

  def initialize(@state : IRCd::State, @commands = Hash(String, IRCd::Command).new)
    IRCd::Commands.each do |command|
      commands[command.key] = command.new(state)
      commands[command.key].aliases.each do |key|
        commands[key] = commands[command.key]
      end
    end
  end

  def handle(client : IRCd::Client)
    FastIRC.parse(client.socket) do |line|
      commands[line.command].handle(client, line)
    end
  end

end
