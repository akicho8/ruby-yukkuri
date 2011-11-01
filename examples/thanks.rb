#!/usr/local/bin/ruby -Ku
# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/ruby_yukkuri/client"))
object = Yukkuri::Client.new
object.talk("ご清聴ありがとうございました。何か質問ありますか？", :sync => true)
sleep(3)
object.talk("ないですね")
