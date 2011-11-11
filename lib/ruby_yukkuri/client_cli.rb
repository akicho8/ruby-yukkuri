# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "client"))
require "optparse"

module Yukkuri
  module ClientCLI
    def self.execute(args)
      config = Yukkuri::Client.new.config
      interactive = false

      oparser = OptionParser.new do |oparser|
        oparser.version = "0.0.2"
        oparser.banner = [
          "棒読みちゃん遠隔操作スクリプト #{oparser.ver}\n",
          "使い方: #{oparser.program_name} [オプション] しゃべらせる言葉...\n",
        ]
        oparser.on("--host=HOSTNAME", "ホスト (default: #{config[:host]})", String){|config[:host]|}
        oparser.on("--port=PORT", "ポート (default: #{config[:port]})", Integer){|config[:port]|}
        oparser.on("--voice=NUMBER", "音質(1-9) 9:初音ミク (default: #{config[:voice]})", Integer){|config[:voice]|}
        oparser.on("--tone=LEVEL", "音程(50-200) (default: #{config[:tone]})", Integer){|config[:tone]|}
        oparser.on("--volume=LEVEL", "音量(1-100) (default: #{config[:volume]})", Integer){|config[:volume]|}
        oparser.on("--speed=VALUE", "速度(50-300) (default: #{config[:speed]})", Integer){|config[:speed]|}
        oparser.on("-i", "--interactive", "コマンドを打たなくていいモード", TrueClass){|interactive|}
        oparser.on_tail("※初期設定ファイル: #{config[:conf_file]}")
      end

      args = oparser.parse(args)
      object = Yukkuri::Client.new(config)

      if interactive
        puts ". で終了"
        STDOUT.sync = true
        loop do
          print "> "
          str = STDIN.gets.strip
          if str == "."
            break
          end
          object.talk(str, config)
        end
      else
        str = args.join(" ").strip
        if str.empty?
          puts oparser
        else
          object.talk(str, config)
        end
      end
    end
  end
end

if $0 == __FILE__
  Yukkuri::ClientCLI.execute(ARGV)
end
