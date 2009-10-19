#!/usr/bin/env ruby
require 'rubygems'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

require "#{APP_ROOT}/vendor/gems/environment"

$: << "#{APP_ROOT}/lib/"

require 'skel'

Skel.run!
