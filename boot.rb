#!/usr/bin/env ruby
require 'rubygems'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

$: << "#{APP_ROOT}/lib/"
# Dir.glob("#{APP_ROOT}/vendor/*/lib/").each do |path|
#   $: << path
# end

require 'skel'

Skel.run!
