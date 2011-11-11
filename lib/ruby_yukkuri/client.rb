# -*- coding: utf-8 -*-
#
# Windows以外からリモートで実行するスクリプト
#

require "kconv"
require "drb/drb"
require "timeout"
require "ping"
require "resolv"
require "pathname"

module Yukkuri
  class Client
    def self.talk(*args, &block)
      object = new(&block)
      object.talk(*args)
    end

    attr_accessor :config

    def initialize(config = {}, &block)
      @config = {
        # :host => "192.168.11.50",
        # :host => "192.168.1.103",
        # :port => 50100,
        :voice  => 1,    # 音質(1-8)
        :tone   => 100,  # 音程(50-200)
        :volume => 100,  # 音量(1-100)
        :speed  => -1,   # 速度(50-300)
        :wait => 10,
        :conf_file => Pathname("~/.ruby-yukkuri"),
      }.merge(config)

      conf_file_read

      if block_given?
        yield @config
      end

      @error_count = 0
    end

    def remote_object
      return @remote_object if @remote_object
      host_with_port = [@config[:host], @config[:port]].join(":")
      if Ping::pingecho(@config[:host], 3, @config[:port])
        @remote_object = DRb::DRbObject.new_with_uri("druby://#{host_with_port}")
      else
        puts "#{host_with_port} に接続できません"
        abort
      end
    end

    def talk(str, options = {})
      options = @config.merge(options)
      if options[:force]
        stop
      end
      if str.to_s.strip.empty?
        return
      end
      safe_block(@config[:wait]) do
        remote_object.talk(str.to_s, [options[:speed], options[:tone], options[:volume], options[:voice]].join(" "))
      end
      if options[:sync]
        wait_loop(str, options)
      end
    end

    def wait_loop(str, options)
      safe_block(30) do
        sleep(str.scan(/./).size * 0.1)
        while @error_count == 0
          resp = remote_talk("/GetNowPlaying")
          if resp.include?("受信：NowPlayingは有効です(音声再生中)")
            sleep(0.25)
          else
            break
          end
        end
      end
    end

    def stop
      remote_talk("/Clear") # 次の行以降をクリア
      remote_talk("/Skip")  # 現在の行をスキップ
    end

    def remote_talk(*args)
      safe_block(@config[:wait]) do
        remote_object.remote_talk(*args).to_s.toutf8
      end
    end

    private

    def safe_block(timeup)
      if @error_count == 0 && remote_object
        begin
          timeout(timeup) do
            yield
          end
        rescue Timeout::Error, DRb::DRbConnError => error
          @error_count += 1
          p error
        end
      end
    end

    def conf_file_read
      conf_file = @config[:conf_file].expand_path
      if conf_file.exist?
        eval(conf_file.expand_path.read, binding)
      end
    end
  end
end

if $0 == __FILE__
  object = Yukkuri::Client.new
  object.talk("ちゃんと繋がってる。問題ない", :sync => false, :tone => 105, :voice => 9, :speed => 120, :volume => 100)
  # object.talk("ちゃんと繋がってる。問題ない", :sync => false, :tone => 100, :voice => 1, :speed => 110, :volume => 50)

  # object.talk("こんにちは", :sync => false, :tone => 130, :voice => 2)
  # object.talk("こんばんは", :sync => false, :tone => 100, :voice => 1)
  # object.talk("ちゃんと繋がってる。問題ない", :sync => false, :tone => 100, :voice => 5)
  # sleep(0.2)
  # object.talk("強制割込み。同期", :sync => true, :force => true) # 割り込み、発声、待ち
  # object.stop

  # if ARGV.empty?
  #   STDOUT.sync = true
  #   loop do
  #     print "> "
  #     object.talk(gets.strip)
  #   end
  # else
  #   object.talk(ARGV.to_s)
  # end
end
