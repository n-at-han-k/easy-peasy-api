ENV['RAILS_ENV'] = 'test'
ENV['BUNDLE_GEMFILE'] = File.expand_path('../example/Gemfile', __dir__)

require 'bundler/setup'
require_relative '../example/config/environment'
require 'minitest/autorun'
require 'rack/test'
