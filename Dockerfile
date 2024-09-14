FROM ruby:3.3.4

# 必要なパッケージと libvips をインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs vim libvips

# アプリケーションのディレクトリを作成
RUN mkdir /myapp
WORKDIR /myapp

# Gemfile と Gemfile.lock を追加
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock

# 必要な Ruby gems をインストール
RUN bundle install

# 残りのアプリケーションコードを追加
ADD . /myapp

# # コンテナがリッスンするポートを指定
# EXPOSE 3000
