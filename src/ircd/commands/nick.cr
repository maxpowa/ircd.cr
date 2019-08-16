# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "../command"

class IRCd::Commands::NickCommand < IRCd::Command
  def self.key
    "NICK"
  end

  def handle(client : IRCd::Client, line : FastIRC::Message)
    client.nick = line.params[0]
  end
end
