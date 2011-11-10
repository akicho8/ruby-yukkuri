#!/usr/bin/env ruby

filename = File.expand_path(File.join(File.dirname(__FILE__), "../lib/ruby_yukkuri/server_cli.sjis.rb"))
if File.exists?(filename)
  require filename
else
  begin
    require "ruby-yukkuri/server_cli.sjis"
  rescue LoadError
    require "rubygems"
    require "ruby-yukkuri/server_cli.sjis"
  end
end
Yukkuri::ServerCLI.execute(ARGV)
