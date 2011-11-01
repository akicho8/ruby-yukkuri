#!/usr/local/bin/ruby -Ku
# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/ruby_yukkuri/client"))
object = Yukkuri::Client.new
object.talk("ちゃんと繋がってる。問題ない1", :sync => false)
object.talk("ちゃんと繋がってる。問題ない2", :sync => false)
object.talk("ちゃんと繋がってる。問題ない3", :sync => false)
puts object.remote_talk("/Clear") # 次の行以降をクリア
puts object.remote_talk("/Skip")  # 現在の行をスキップ
