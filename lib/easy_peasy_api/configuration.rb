module EasyPeasyApi
  class Configuration
    attr_accessor :path

    def initialize
      @path = nil
    end

    # Returns the path with leading slash, no trailing slash
    def normalized_path
      return nil unless @path

      p = @path.to_s
      p = "/#{p}" unless p.start_with?('/')
      p.chomp('/')
    end

    # Converts the configured path to a module prefix
    # e.g. "/api/v1" => "Api::V1"
    def controller_module_prefix
      return nil unless normalized_path

      normalized_path.delete_prefix('/').split('/').map { |s| s.camelize }.join('::')
    end

    # Returns the filesystem directory under app/controllers for this path
    # e.g. "/api/v1" => "api/v1"
    def controller_directory
      return nil unless normalized_path

      normalized_path.delete_prefix('/')
    end
  end
end
