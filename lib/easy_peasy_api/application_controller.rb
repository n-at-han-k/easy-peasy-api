module EasyPeasyApi
  class ApplicationController < ActionController::API
    before_action :set_default_params

    private

    # Called automatically. Applies the middleware's default param names.
    def set_default_params
      default_names = request.env['easy_peasy_api.default_param_names']
      values = request.env['easy_peasy_api.dynamic_values']
      return unless default_names && values

      set_params(*default_names)
    end

    # Rebuild path_parameters with the given names mapped to the ordered
    # dynamic segment values the middleware extracted from the URL.
    #
    # Call this inside any action (or a before_action) to rename params:
    #
    #   def show
    #     set_params :customer_id, :id
    #   end
    #
    def set_params(*names)
      values = request.env['easy_peasy_api.dynamic_values']
      return unless values

      path_params = {
        controller: request.path_parameters[:controller],
        action: request.path_parameters[:action]
      }

      names.each_with_index do |name, i|
        path_params[name.to_sym] = values[i] if i < values.length
      end

      request.path_parameters = path_params
    end
  end
end
