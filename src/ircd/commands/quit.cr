# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "../command"

class IRCd::Commands::QuitCommand < IRCd::Command
  def self.key
    "QUIT"
  end

  def handle(client : IRCd::Client, line : FastIRC::Message)
    client.quit(line.params[-1])
  end
end
