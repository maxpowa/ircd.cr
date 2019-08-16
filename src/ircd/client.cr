# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "socket"

class IRCd::Client
  getter! socket : TCPSocket
  getter! server : TCPServer
  property! nick : String

  def initialize(@socket, @server)
  end

  def close
    socket.close
  end

  def write(raw : String)
    socket.puts(raw)
  end

  def recieve
    yield socket.gets
  end

  def recieve
    socket.gets
  end

  def closed?
    socket.closed?
  end

end
