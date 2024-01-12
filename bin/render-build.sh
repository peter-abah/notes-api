#!/usr/bin/env bash
# exit on error
set -o errexit

bundle config set force_ruby_platform true

bundle install

rails db:migrate

./bin/rails assets:precompile
./bin/rails assets:clean
