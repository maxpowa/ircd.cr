# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "../command"

class IRCd::Commands::UserCommand < IRCd::Command
  def self.key
    "USER"
  end

  def handle(client : IRCd::Client, line : FastIRC::Message)
    @state.push(client)
  end
end
