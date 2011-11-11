# -*- coding: cp932 -*-
#
# Windows side server script
#
#   Yukkuri::Server.start
#

require "drb/drb"
if RUBY_PLATFORM.match(/mswin32/)
  require "win32ole"
end
require "pathname"
require "kconv"

module Yukkuri
  class Server
    attr_accessor :config

    def initialize(config = {}, &block)
      @config = {
        :bouyomi_command => command_find("BouyomiChan/RemoteTalk/RemoteTalk.exe"),
        :softalk_command => command_find("softalk/SofTalk.exe"),
        :host            => nil,
        :port            => nil,
      }.merge(config)

      if block_given?
        yield @config
      end
    end

    def start(message = "ok")
      puts "BouyomiChan: #{@config[:bouyomi_command]}"
      talk(message)
      if @config[:host]
        uri = "druby://#{@config[:host]}:#{@config[:port]}"
      else
        uri = nil
      end
      DRb.start_service(nil, self)
      puts DRb.uri
      puts "[ENTER] to exit"
      STDIN.gets
    end

    def talk(str, args = "")
      str = str.to_s.tosjis.gsub(/"/, "").strip
      if str.empty?
        return
      end
      remote_talk("/Talk \"#{str}\" #{args}")
    end

    def remote_talk(args)
      puts args
      command = "#{@config[:bouyomi_command]} #{args}"
      `#{command}`
    end

    def softalk(str, options = {})
      str = str.tosjis.gsub(/"/, "")
      command = "start #{@softalk_command} #{options[:softalk_options]} /W:\"#{str}\""
      puts command
      system(command)
    end

    def command_find(command)
      found = nil
      [
        "~/Desktop",
        ENV["ProgramFiles"],
        ENV["ProgramFiles(x86)"],
      ].each{|path|
        path = Pathname(path).expand_path + command
        if path.exist?
          found = path
          break
        end
      }
      found
    end
  end
end
