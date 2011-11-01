#!/usr/local/bin/ruby -Ku
# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/ruby_yukkuri/client"))
object = Yukkuri::Client.new
object.talk(ARGV.to_s, :tone => 100, :voice => 1, :speed => 100, :volume => 80)
