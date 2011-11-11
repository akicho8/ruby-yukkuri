Windowsの棒読みちゃんをMacから操作するスクリプト
================================================

Windows側の手順
---------------

1. 棒読みちゃん起動
2. yukkuri_server_start.bat 実行
3. 待機状態になったらOK (※終了はリターン)

Mac側の手順
-----------

### 設定を毎回引数で設定するのは面倒なので ~/.ruby-yukkuri に書いておくと楽ちん

    $ emacs ~/.ruby-yukkuri
    $ cat ~/.ruby-yukkuri
    # -*- coding: utf-8; mode: ruby -*-
    @config.update({
        :port   => 49375,           # drbポート
        :host   => "192.168.11.50", # drbサーバーIP
        :voice  => 9,               # 音質(1-8) 9:初音ミク
        :tone   => 105,             # 音程(50-200)
        :volume => 100,             # 音量(1-100)
        :speed  => 95,              # 速度(50-300)
      })
      
### あとは y コマンドでWindows側の棒読みちゃんがしゃべる
      
    $ y こんにちは

### 接続が不安定な場合は y -i で起動するといいかも
      
    $ y -i
    > こんにちは
    > こんばんは
    > なんとか
    > かんとか

初音ミク対応
------------

棒読みちゃんで初音ミク(購入する必要あり)の設定をすれば voice=9 で初音ミクの声でしゃべらせられます

    $ y --voice=9 ふるぼっこにしてやんよ
