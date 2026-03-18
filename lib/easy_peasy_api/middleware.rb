require 'action_dispatch'
require 'active_support/inflector'

module EasyPeasyApi
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      config = EasyPeasyApi.configuration
      prefix = config&.normalized_path

      return @app.call(env) unless prefix

      request_path = env['PATH_INFO'].to_s

      return @app.call(env) unless path_matches?(request_path, prefix)

      relative = request_path.delete_prefix(prefix).delete_prefix('/')
      return @app.call(env) if relative.empty?

      segments = relative.split('/').reject(&:empty?)
      return @app.call(env) if segments.empty?

      resolution = resolve(segments, config)
      return not_found unless resolution

      controller_class, dynamic_pairs = resolution

      # dynamic_pairs is an ordered array of [default_name, value]
      # e.g. [[:uncontacted_id, "234234"], [:id, "999"]]
      has_id = dynamic_pairs.any? { |name, _| name == :id }

      request_method = env['REQUEST_METHOD']
      action = determine_action(request_method, has_id)
      return method_not_allowed unless action

      dispatch(controller_class, action, dynamic_pairs, env)
    end

    private

    def path_matches?(request_path, prefix)
      request_path == prefix || request_path.start_with?("#{prefix}/")
    end

    def resolve(segments, config)
      controllers_root = Rails.root.join('app', 'controllers', config.controller_directory).to_s
      mod_prefix = config.controller_module_prefix

      result = walk(segments, controllers_root, [], [], nil)
      return nil unless result

      controller_segments, dynamic_pairs = result
      klass = constantize_controller(mod_prefix, controller_segments)
      return nil unless klass

      [klass, dynamic_pairs]
    end

    # Recursive filesystem walk.
    #
    # Returns [controller_segments, dynamic_pairs] where dynamic_pairs is
    # an ordered array of [default_param_name, value].
    def walk(segments, current_dir, controller_segments, dynamic_pairs, last_dir_name)
      return nil if segments.empty?

      segment = segments.first
      rest = segments[1..]

      controller_file = File.join(current_dir, "#{segment}_controller.rb")
      has_controller = File.exist?(controller_file)
      subdir = File.join(current_dir, segment)
      has_directory = File.directory?(subdir)

      # 1. Try descending into a subdirectory first (most specific match wins)
      if has_directory
        result = walk(rest, subdir, controller_segments + [segment], dynamic_pairs, segment)
        return result if result
      end

      # 2. Try matching a controller file
      if has_controller
        found_segments = controller_segments + [segment]

        if rest.empty?
          return [found_segments, dynamic_pairs]
        elsif rest.length == 1
          return [found_segments, dynamic_pairs + [[:id, rest.first]]]
        end
      end

      # 3. No directory or controller match — dynamic param
      if last_dir_name
        param_name = :"#{last_dir_name.singularize}_id"
        return walk(rest, current_dir, controller_segments, dynamic_pairs + [[param_name, segment]], last_dir_name)
      end

      nil
    end

    def constantize_controller(mod_prefix, segments)
      class_name = segments.map { |s| s.camelize }.join('::')
      full_name = "#{mod_prefix}::#{class_name}Controller"
      full_name.constantize
    rescue NameError
      nil
    end

    def dispatch(controller_class, action, dynamic_pairs, env)
      default_names = dynamic_pairs.map(&:first)
      values = dynamic_pairs.map(&:last)

      # Store ordered data for set_params
      env['easy_peasy_api.dynamic_values'] = values
      env['easy_peasy_api.default_param_names'] = default_names

      # Set path_parameters with default names so it works out of the box
      path_params = { controller: controller_class.controller_path, action: action.to_s }
      dynamic_pairs.each { |name, value| path_params[name] = value }

      env['action_dispatch.request.path_parameters'] = path_params

      controller_class.action(action).call(env)
    end

    def determine_action(method, has_id)
      if has_id
        case method
        when 'GET'          then :show
        when 'PUT', 'PATCH' then :update
        when 'DELETE'       then :destroy
        end
      else
        case method
        when 'GET'  then :index
        when 'POST' then :create
        end
      end
    end

    def not_found
      [404, { 'content-type' => 'application/json' }, ['{"error":"Not Found"}']]
    end

    def method_not_allowed
      [405, { 'content-type' => 'application/json' }, ['{"error":"Method Not Allowed"}']]
    end
  end
end
