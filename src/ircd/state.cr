# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "./config/*"
require "./channel"
require "./client"

class IRCd::State
  property! config : IRCd::Config::Mapping
  property! channels : Array(IRCd::Channel)
  property! clients : Array(IRCd::Client)

  def initialize(@config : IRCd::Config::Mapping, @channels = Array(IRCd::Channel).new, @clients = Array(IRCd::Client).new)
  end
end
