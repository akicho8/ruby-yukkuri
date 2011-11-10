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
        :bouyomi_command => "..\\..\\BouyomiChan\\RemoteTalk\\RemoteTalk",
        :softalk_command => "..\\..\\softalk\\SofTalk",
        :host            => "localhost",
        :port            => 50100,
      }.merge(config)

      if block_given?
        yield @config
      end
    end

    def start(message = "ok")
      talk(message)
      DRb.start_service("druby://#{@config[:host]}:#{@config[:port]}", self)
      p DRb.uri
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
      command = "#{@config[:bouyomi_command]} #{args}"
      puts command
      `#{command}`
    end

    def softalk(str, options = {})
      str = str.tosjis.gsub(/"/, "")
      command = "start #{@softalk_command} #{options[:softalk_options]} /W:\"#{str}\""
      puts command
      system(command)
    end
  end
end
