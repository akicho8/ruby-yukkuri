# -*- coding: utf-8 -*-
require "drb/drb"
DRb.start_service
obj = DRbObject.new_with_uri("druy://#{ARGV}")
p obj + " World"
