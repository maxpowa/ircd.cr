# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "socket"
require "./state"
require "./dispatcher"

struct IRCd::Server
  getter! clients : Array(IRCd::Client)
  getter! config : IRCd::Config::Mapping
  getter! server : TCPServer
  getter! state : IRCd::State

  def initialize(@config : IRCd::Config::Mapping)
    @clients = Array(IRCd::Client).new
    @server = TCPServer.new(@config.interface, @config.port)
    @state = IRCd::State.new(@config)
    @dispatcher = IRCd::Dispatcher.new(state)
  end

  def start
    spawn do
      loop do
        accept do |client|
          # Dispatcher pulls lines from client
          spawn dispatcher.handle(client)
        end
      end
    end
    Fiber.yield
  end

  def accept
    @server.accept do |socket|
      client = IRCd::Client.new(socket, self)
      begin
        @clients.push(client)
        yield client
      ensure
        client.close
        @clients.pop(client)
      end
    end
  end

  def write
    @state.clients.each do |client|
      client.write()
    end
  end
end
