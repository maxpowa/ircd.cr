# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

module IRCd::Commands
  COMMANDS = Array(IRCd::Command.class).new

  def self.register(command)
    COMMANDS.push(command)
  end

  def self.each
    COMMANDS.each do |command|
      yield command
    end
  end
end

abstract class IRCd::Command
  property aliases = Array(String).new

  def self.key
    raise "command key unset"
  end

  def initialize(@state : IRCd::State)

  end

  abstract def handle(client : IRCd::Client, line : FastIRC::Message)

  macro inherited
    # Register the command automagically
    IRCd::Commands.register({{@type.id}})
  end
end
