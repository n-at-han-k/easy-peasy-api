require 'rails/railtie'

module EasyPeasyApi
  class Railtie < Rails::Railtie
    initializer 'easy_peasy_api.middleware' do |app|
      app.middleware.use EasyPeasyApi::Middleware
    end
  end
end
