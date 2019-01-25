#! usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'
Bundler.require

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'scrapper'

require 'app/fichier_1'
require 'views/fichier_2'

MyClass.new.perform
