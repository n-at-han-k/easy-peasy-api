require 'easy_peasy_api/version'
require 'easy_peasy_api/configuration'
require 'easy_peasy_api/middleware'
require 'easy_peasy_api/railtie' if defined?(Rails::Railtie)

module EasyPeasyApi
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

require 'easy_peasy_api/application_controller' if defined?(ActionController::API)
