# Ans::Resque::Check

Resque のキューの内容をチェックする

溜まりすぎていたり、失敗があった場合にコールバックを呼び出す

## Installation

Add this line to your application's Gemfile:

    gem 'ans-resque-check'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ans-resque-check

## Usage

    # config/initializers/ans-resque-check.rb
    Ans::Resque::Check.configure do |config|
      config.on_notice << lambda{|e|
        # エラー通知等
        #ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
      }
    end

    # config/route.rb
    Application.routes.draw do
      mount Ans::Resque::Check::Engine => "/ans-resque-check"
    end

    # crontab
    0 * * * * curl http://host.domain/ans-resque-check > /dev/null 2>&1

`Ans::Resque::Check.configure` で、通知時に呼び出されるコールバックを設定  
コントローラーのコンテキストから呼び出される  
引数は `Ans::Resque::Check::Notice` で、 `StandardError` の継承クラスだが、 raise されているわけではないので `$!` では参照できない

get アクセスを受け付けるルーティングが作成され、検出した情報を出力する

    queue1:10,queue2:20,failed:30

このアクションに、一時間に一回アクセスしてチェックを行う  
失敗があると、常に通知が来るので、一時間に一回のチェックくらいがちょうどいいのでは

## 設定可能な設定とデフォルト

    # config/initializers/ans-resque-check.rb
    Ans::Resque::Check.configure do |config|
      config.queue_notice_threshold = 500 # 通常のキューにこれだけたまったら通知
      config.failed_notice_threshold = 0 # 失敗のキューにこれだけたまったら通知

      config.on_notice << lambda{|e|
        # デフォルトは設定されていない
      }
      config.on_notice << lambda{|e|
        # 複数回設定すると、最初に設定したブロックから順に全て呼び出される
      }
    end

## Contributing

1. Fork it ( http://github.com/<my-github-username>/ans-resque-check/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
