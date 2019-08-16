# This file is part of ircd.cr
# Copyright (C) 2016 Max Gurela <max.gurela@outlook.com>
# Released under the terms of the MIT license (see LICENSE).

require "yaml"
require "logger"

struct IRCd::Config::Types
  LOG = Logger.new(STDOUT)

  class Prefix
    DEFAULT = {'o' => '@', 'h' => '%', 'v' => '+'}

    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      match = input.match /\(([^)]+)\)(.+)/

      output = Hash(Char, Char).new

      unless match && match[1].size == match[2].size
        LOG.warn "invalid prefix config, groups do not match - defaulting to '(ohv)@%+'"
        return DEFAULT
      end

      modes = match[1]
      prefixes = match[2]

      chars = prefixes.chars
      modes.chars.each do |mode|
        output[mode] = chars.shift
      end
      output
    end

    def self.to_yaml(input : Hash(Char, Char), emitter : YAML::Emitter)
      emitter << "(#{input.keys.join})#{input.values.join}"
    end
  end

  class KeyArray
    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      output = Array(Char).new
      input.chars.each do |chunk|
        output << chunk
      end
      output
    end

    def self.to_yaml(input : Array(Char), emitter : YAML::Emitter)
      emitter << input.join
    end
  end

  class MultiKVMap
    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      output = Hash(Char, String).new
      input.split(',').each do |chunk|
        prefix, val = chunk.split(':')
        prefix.chars.each do |key|
          output[key] = val
        end
      end
      output
    end

    def self.to_yaml(input : Hash(Char, String), emitter : YAML::Emitter)
      mapping = Hash(String, Array(Char)).new
      input.each do |key, value|
        unless mapping.has_key? value
          mapping[value] = Array(Char).new
        end
        mapping[value].push(key)
      end
      output = Array(String).new
      mapping.each do |key, value|
        output.push("#{value.join}:#{key}")
      end
      emitter << output.join(',')
    end
  end

  class ChanLimit < MultiKVMap
    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      map = super
      output = Hash(Char, Int32).new
      map.each do |key, value|
        begin
          output[key] = value.to_i32
        rescue ex : ArgumentError
          LOG.warn "invalid chanlimit config, unable to cast '#{value}' to Int32 - skipping '#{key}'"
        end
      end
      output
    end

    def self.to_yaml(input : Hash(Char, Int32), emitter : YAML::Emitter)
      mapping = Hash(Int32, Array(Char)).new
      input.each do |key, value|
        unless mapping.has_key? value
          mapping[value] = Array(Char).new
        end
        mapping[value].push(key)
      end
      output = Array(String).new
      mapping.each do |key, value|
        output.push("#{value.join}:#{key}")
      end
      emitter << output.join(',')
    end
  end

  class ChanModes
    def self.to_yaml(input : Array(Array(Char)), emitter : YAML::Emitter)
      output = Array(String).new
      input.each do |part|
        output.push part.join
      end
      emitter << output.join(',')
    end

    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      parts = input.split(',', 4)
      if (parts[-1].includes? ',')
        LOG.warn "improper chanmodes config, too many commas - removing commas and merging group"
        parts[-1] = parts[-1].sub(',', nil)
      end
      unless parts.size == 4
        LOG.warn "improper chanmodes config, too few pieces specified - falling back to default 'beI,k,l,imnpsta'"
        parts = ["beI", "k", "l", "imnpsta"]
      end
      output = Array(Array(Char)).new
      parts.each do |part|
        output.push part.chars
      end
      output
    end
  end

  class MaxList < MultiKVMap
    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      map = super
      output = Hash(Char, Int32).new
      map.each do |key, value|
        begin
          output[key] = value.to_i32
        rescue ex : ArgumentError
          LOG.warn "invalid maxlist config, unable to cast '#{value}' to Int32 - skipping '#{key}'"
        end
      end
      output
    end

    def self.to_yaml(input : Hash(Char, Int32), emitter : YAML::Emitter)
      mapping = Hash(Int32, Array(Char)).new
      input.each do |key, value|
        unless mapping.has_key? value
          mapping[value] = Array(Char).new
        end
        mapping[value].push(key)
      end
      output = Array(String).new
      mapping.each do |key, value|
        output.push("#{value.join}:#{key}")
      end
      emitter << output.join(',')
    end
  end

  class CharValue
    def self.to_yaml(input : Char, emitter : YAML::Emitter)
      emitter << input.to_s
    end

    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      if input.size > 1
        raise ArgumentError.new "more than one character provided"
      end
      input.chars[0]
    end
  end

  class CaseMapping
    def self.from_yaml(pull : YAML::PullParser)
      from_yaml pull.read_scalar
    end

    def self.from_yaml(input : String)
      case input.downcase
      when "ascii", "rfc1459", "strict-rfc1459"
        return input.downcase
      else
        LOG.warn "invalid casemapping, falling back to 'ascii'"
        return "ascii"
      end
    end
  end

  alias StatusMsg = KeyArray
  alias ChanTypes = KeyArray
end
