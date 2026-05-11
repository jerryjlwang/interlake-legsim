# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.1.2
FROM ruby:${RUBY_VERSION}-slim-bullseye AS base

WORKDIR /rails

ENV BUNDLE_DEPLOYMENT=true \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      default-libmysqlclient-dev \
      default-mysql-client \
      git \
      imagemagick \
      libvips42 \
      nodejs \
      pkg-config && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.4.2 && \
    bundle install && \
    rm -rf ~/.bundle/ /usr/local/bundle/ruby/*/cache

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 SECRET_KEY_BASE=dummy bin/rails assets:precompile && \
    useradd --create-home --shell /bin/bash rails && \
    mkdir -p log tmp storage public/assets && \
    chown -R rails:rails log tmp storage public/assets

USER rails

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
