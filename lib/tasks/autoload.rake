namespace :autoload do
  desc "TODO"
  task find_unloaded: :environment do
    # Path pruning rules
    base_path = "^#{Dir.pwd}\/"
    gem_path = ".*\/.rvm\/gems\/.*\/gems\/.*\/"
    app_paths = %w(app/assets app/channels app/controllers app/helpers app/jobs app/mailers app/models app/views lib)
    app_paths = app_paths.map {|path| "(#{path.gsub('/', '\/')}/)" }.join('|')

    prune = Regexp.new("((#{base_path})|(#{gem_path}))(#{app_paths})(concerns)?")
    postfix = /\.rb$/

    # Get files
    files = ActiveSupport::Dependencies.autoload_paths.map { |path| Dir.glob("#{path}/**/*.rb") }.flatten
    files.select! { |file| file.match(postfix) }
    files.map! { |file| file.gsub(prune, '').gsub(postfix, '') }

    # Check which files are not loaded
    files.each do |file|
      begin
        Object.const_defined? ActiveSupport::Inflector.camelize(file)
      # Object.const_defined? fails with NameError, when rake task runs in shell
      rescue NameError => e
        puts file
      end
    end
  end
end
