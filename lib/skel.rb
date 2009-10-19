# require 'jcode'
require 'json'
require 'uri'
# require 'ruby-debug'
require 'extlib'
require 'log4r'

# Sinatra Plugins & Helpers 
require 'sinatra/base'
require 'sinatra/erubis'
require 'sinatra/static_assets'

# require 'sinatra/static_assets_monkeypatch'
require 'sinatra/content_for'
require 'sinatra/respond_to'

require 'sinatra/mailer'
require 'redis-store'

# DataMapper plugins

require 'do_mysql'
require 'dm-core'
require 'dm-aggregates'
require 'dm-validations'

# require 'dm-tags'
# require 'dm-is-tree'
# require 'dm-paperclip'

require 'skel/core-ext'
acquire 'skel/helper/*'

module Skel
  class App < Sinatra::Base
    include Log4r

    @@logger = nil;

    # loading config 
    instance_eval IO.read("#{APP_ROOT}/config/config.rb")

    # load helpers
    helpers Sinatra::ErubisTemplate
    helpers Sinatra::UrlForHelper
    helpers Sinatra::StaticAssets
    helpers Sinatra::ContentFor

    # helpers WillPaginate::ViewHelpers::Base
    register Sinatra::RespondTo
    register Sinatra::Mailer

    # load routes
    def initialize(option={})
      setup_log    if options.respond_to?( :logger_conf ) && options.logger_conf.key?(:output)

      Sinatra::Mailer.config = options.mailer_conf if options.respond_to?( :mailer )

      unless options.respond_to? :database
        raise "options.database is not defined."
      else
        DataMapper::setup(:default, options.database) 
      end

      # load all models
      acquire options.models + "/*"

      super(option)
    end

    private

    def setup_log# {{{
      # create outputter
      if options.environment == :development
        out = Log4r::IOOutputter.new('stderr',$stderr)
      else
        out = Log4r::FileOutputter.new("file", :filename => self.logger_conf[:output] )
      end

      # datamapper logger
      dm_logger = Log4r::Logger.new("datamapper-")

      # register datamapper logger
      DataMapper.logger = dm_logger
      DataObjects::Mysql.logger = DataMapper.logger

      dm_logger.outputters = out

      # rack logger
      rack_logger = Log4r::Logger.new("rack")
      rack_logger.outputters = out

      # register rack logger
      use Rack::CommonLogger, rack_logger

      # app logger
      @@logger = Log4r::Logger.new("application")

      logger.outputters = out
    end# }}}

    before do # {{{ handling nested params : http://www.sinatrarb.com/book.html#before_do
      new_params = {}
      params.each_pair do |full_key, value|
        this_param = new_params
        split_keys = full_key.split(/\]\[|\]|\[/)
        split_keys.each_index do |index|
          break if split_keys.length == index + 1
          this_param[split_keys[index]] ||= {}
          this_param = this_param[split_keys[index]]
        end
        this_param[split_keys.last] = value
      end
      request.params.replace new_params
    end # before# }}}
  end
end
