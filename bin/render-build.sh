#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:clean
bundle exec rake assets:precompile
# 以下は、データをリセットするものなので、必要に応じてコメントアウト
bundle exec rake db:reset --trace
bundle exec rake db:seed --trace
