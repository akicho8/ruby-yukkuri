#!/usr/bin/env ruby
begin
  require "ruby-yukkuri/server_cli"
rescue LoadError
  require "rubygems"
  require "ruby-yukkuri/server_cli"
end
Yukkuri::ServerCLI.execute(ARGV)
