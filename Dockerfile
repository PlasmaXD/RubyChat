# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.1.0

# ベースイメージとしてRubyを使用
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as ruby_base

# Node.jsを使ったビルドステージ
FROM node:14-alpine as node_build

# 必要なディレクトリの作成と依存関係のインストール
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

# アプリケーションコードのコピー
COPY . .

# 最終ビルドステージ
FROM ruby_base as final_build

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config curl

# Node.jsのインストール
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# GemfileとGemfile.lockのコピーとバンドルのインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# アプリケーションコードのコピー
COPY . .

# Babel関連のパッケージをインストール
RUN yarn add babel-loader@8.2.3 @babel/core @babel/preset-env @babel/plugin-syntax-dynamic-import

# Webpackのキャッシュをクリア
RUN yarn cache clean

# 最終ステージ
FROM ruby_base as final_stage

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ビルドステージからバンドルされたGemとアプリケーションをコピー
COPY --from=final_build /usr/local/bundle /usr/local/bundle
COPY --from=final_build /rails /rails

# Railsユーザーの作成と権限設定
RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p /rails/db /rails/log /rails/storage /rails/tmp && \
    chown -R rails:rails /rails/db /rails/log /rails/storage /rails/tmp

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
