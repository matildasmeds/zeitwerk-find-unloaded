# frozen_string_literal: do

namespace :find_unloaded do
  desc 'Identify ruby files whose path does not match a defined constant'
  task find: :environment do
    Rails.configuration.eager_load_namespaces.each(&:eager_load!)
    # Get files
    files = []
    ActiveSupport::Dependencies.autoload_paths.each do |path|
      path_regexp = Regexp.new("^#{path}/")
      expanded_path = Dir.glob("#{path}/**/*.rb")
      expanded_path.each { |file| files << file.gsub(path_regexp, '') }
    end
    files.select! { |file| file.match('.rb') }
    files.map! { |file| file.gsub('.rb', '') }

    # Check which files are not loaded
    files.each do |file|
      Object.const_defined? ActiveSupport::Inflector.camelize(file)
    rescue NameError
      puts file
    end
  end
end
