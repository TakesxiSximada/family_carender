# Family Calendar

## 必要なもの

- Ruby 2.1.5 ぐらい

## 初期設定

```sh
$ git clone https://github.com/TakesxiSximada/family_carender.git
$ gem install bundler
$ cd family_carender
$ bundle install --path vendor/bundle
$ bundle exec ruby app.rb
```

html等の静的ファイルは /public に入れれば http://localhost:4567 から見えるはずです。

## Bluemix

トップ画面
http://family-calendar.mybluemix.net/index.html

WatsonのSpeech To TextにWAVファイルを送るテスト
http://family-calendar.mybluemix.net/watson_post.html

