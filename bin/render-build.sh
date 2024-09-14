#!/usr/bin/env bash
# exit on error
set -o errexit

# 必要な gems をインストール
bundle install

# アセットのクリーニングとプリコンパイル
bundle exec rake assets:clean
bundle exec rake assets:precompile

# データベースのリセット（シードも含めて）
# 必要に応じてコメントアウト
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed

# データベースのマイグレーション
bundle exec rake db:migrate --trace
