Web Application
===============

最も単純な例
------------

以下の `config.ru`, `app.rb` はRackを直接利用した Web Application の最も単純な例です。

```
# config.ru
require ::File.expand_path('../app.rb', __FILE__)

run SimpleApp.new

# app.rb
class SimpleApp
  def call(env)
    # your webapp code here

    [
      200,
      { 'Content-Type' => 'text/html; charset=UTF-8' },
      ['Hello World']
    ]
  end
end

```

起動方法

```
$ gem install rack # rackupのインストール
$ rackup           # defaultでconfig.ruが使われる
Puma 1.6.3 starting...
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://0.0.0.0:9292
```

実習(1)
-------

1. ブラウザや `curl` コマンドで http://サーバ名:ポート番号/ にアクセスして、Hello World が表示されることを確認してください
2. サーバ上で `ngrep` コマンドを用いて listen している port への通信をキャプチャし、どのような HTTP のやり取りがなされているかを確認してください
```
$ ngrep -d eth0 -W byline port 5000
```
3. `spec/basic_spec.rb` のテストが通ることを確認してください
4. `env` にどのようなデータが渡ってきているか、中身を確認してください

課題(1)
-------

1. `html` ディレクトリに存在するHTMLファイルを利用して、`spec/webapp_spec.rb` のテストが通る Web Application を `config.ru` に実装してください


フレームワーク(Sinatra)を使った Web Application
------------

インストールとセットアップ

```
$ gem install bundler
$ bundle init
$ echo 'gem "sinatra"' >> ./Gemfile
$ bundle install --path=vendor/bundle

$ cat << EOF > ./app.rb
require 'sinatra'

get '/' do
  "Hello World"
end
EOF
$ cat << EOF > ./config.ru
require_relative 'app'

run Sinatra::Application
EOF
$ bundle exec rackup
```

課題(2)
-------

1. 課題(1) で作成した Web Application を Sinatra 上で動作するように移植し、spec/webapp_spec.rb のテストが通るようにしてください
