# syntax=docker/dockerfile:1
FROM ruby:3.2

# Node18 + Yarn1 をインストール（安定版）
RUN apt-get update -qq && \
    apt-get install -y curl gnupg build-essential libsqlite3-0 libvips libyaml-dev && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@1.22.22

WORKDIR /app

# Ruby gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.6.9 && bundle install

# Node パッケージ（package.json がある場合）
COPY package.json yarn.lock ./
RUN yarn install --network-timeout 600000

# アプリ全体
COPY . .
