# -*- coding: utf-8 -*-
require "drb/drb"
DRb.start_service(nil, "Hello")
p DRb.uri
STDIN.gets
