# vim: set syn=ruby:

require 'rubygems'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

$: << "#{APP_ROOT}/lib/"

require 'skel'

run Skel.new

