#! usr/bin/env ruby
require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'scrapper'

require 'app/fichier_1'
require 'views/fichier_2'

MyClass.new.perform