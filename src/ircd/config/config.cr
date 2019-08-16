# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "yaml"
require "logger"
require "./types"

module IRCd::Config
  class Mapping
    LOG = Logger.new(STDOUT)

    def self.load(config_path : String)
      unless File.file? config_path
        LOG.warn "no existing config file found at '#{config_path}', generating new"
        File.write(config_path, YAML.dump(from_yaml("--- {}")))
      end
      config = from_yaml(File.read(config_path))
      config.config_path = config_path
      config
    end

    property! config_path : String

    YAML.mapping(
      network: {
        type: String,
        default: "ircd.cr"
      },
      interface: {
        type: String,
        default: "0.0.0.0"
      },
      port: {
        type: Int32,
        default: 6667
      },
      timeout: {
        type: Int32,
        default: 180
      },
      verbose: {
        type: Bool,
        default: false
      },
      prefix: {
        type: Hash(Char, Char),
        default: Types::Prefix.from_yaml("(ohv)@%+"),
        converter: Types::Prefix
      },
      chantypes: {
        type: Array(Char),
        default: Types::ChanTypes.from_yaml("#&"),
        converter: Types::ChanTypes
      },
      chanmodes: {
        type: Array(Array(Char)),
        default: Types::ChanModes.from_yaml("beI,k,l,imnpsta"),
        converter: Types::ChanModes
      },
      modes: {
        type: Int32,
        default: 4
      },
      chanlimit: {
        type: Hash(Char, Int32),
        default: Types::ChanLimit.from_yaml("#&:10"),
        converter: Types::ChanLimit
      },
      nicklen: {
        type: Int32,
        default: 9
      },
      maxlist: {
        type: Hash(Char, Int32),
        default: Types::MaxList.from_yaml("beI:30"),
        converter: Types::MaxList
      },
      excepts: {
        type: Char,
        default: 'e',
        nillable: true,
        converter: Types::CharValue
      },
      invex: {
        type: Char,
        default: 'I',
        nillable: true,
        converter: Types::CharValue
      },
      statusmsg: {
        type: Array(Char),
        default: Types::StatusMsg.from_yaml("+@"),
        converter: Types::StatusMsg
      },
      # casemapping: {
      #   type: String,
      #   default: "ascii",
      #   converter: Types::CaseMapping
      # },
      topiclen: {
        type: Int32,
        default: 160
      },
      kicklen: {
        type: Int32,
        default: 160
      },
      channellen: {
        type: Int32,
        default: 50
      },
      awaylen: {
        type: Int32,
        default: 160
      },
      maxtargets: {
        type: Int32,
        default: 4
      },
      watch: {
        type: Int32,
        default: 64
      },
      whox: {
        type: Bool,
        default: true
      }
    )
  end
end
