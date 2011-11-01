# -*- coding: cp932 -*-

require File.expand_path(File.join(File.dirname(__FILE__), "server.sjis"))
require "optparse"

module Yukkuri
  module ServerCLI
    def self.execute(args)
      config = Yukkuri::Server.new.config
      oparser = OptionParser.new do |oparser|
        oparser.version = "0.0.1"
        oparser.on("--bouyomi=COMMAND", "BouyomiChan Command (default: #{config[:bouyomi_command]})"){|config[:bouyomi_command]|}
        oparser.on("--softalk=COMMAND", "Softalk Command (default: #{config[:softalk_command]})"){|config[:softalk_command]|}
        oparser.on("--host=HOSTNAME", "Hostname (default: #{config[:host]})"){|config[:host]|}
        oparser.on("--port=PORT", "Port (default: #{config[:port]})"){|config[:port]|}
      end
      args = oparser.parse(args)
      Yukkuri::Server.new(config).start(args.join(" "))
    end
  end
end

if $0 == __FILE__
  Yukkuri::ServerCLI.execute(ARGV)
end
