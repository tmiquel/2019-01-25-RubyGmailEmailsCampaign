require 'bundler'
Bundler.require

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'scrapper'


scrapper = Scrapper.new
scrapper.perform

#@Nico
