# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "client"))
require "optparse"

module Yukkuri
  module ClientCLI
    def self.execute(args)
      config = Yukkuri::Client.new.config
      options = Yukkuri::Client.new.default_talk_options
      interactive = false

      oparser = OptionParser.new do |oparser|
        oparser.version = "0.0.1"
        oparser.on("--host=HOSTNAME", "ホスト (default: #{config[:host]})", String){|config[:host]|}
        oparser.on("--port=PORT", "ポート (default: #{config[:port]})", Integer){|config[:port]|}
        oparser.on("--voice=NUMBER", "音質(1-9) 9:初音ミク (default: #{options[:voice]})", Integer){|options[:voice]|}
        oparser.on("--tone=LEVEL", "音程(50-200) (default: #{options[:tone]})", Integer){|options[:tone]|}
        oparser.on("--volume=LEVEL", "音量(1-100) (default: #{options[:volume]})", Integer){|options[:volume]|}
        oparser.on("--speed=VALUE", "速度(50-300) (default: #{options[:speed]})", Integer){|options[:speed]|}
        oparser.on("-i", "--interactive", "コマンドを打たなくていいモード", TrueClass){|interactive|}
      end

      args = oparser.parse(args)
      object = Yukkuri::Client.new(config)

      if interactive
        STDOUT.sync = true
        loop do
          print "> "
          object.talk(gets.strip, options)
        end
      else
        object.talk(args.join(" "), options)
      end
    end
  end
end

if $0 == __FILE__
  Yukkuri::ClientCLI.execute(ARGV)
end
