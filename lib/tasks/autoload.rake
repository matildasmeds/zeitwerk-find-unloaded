namespace :autoload do
  desc "TODO"
  task find_unloaded: :environment do
    paths = {}
    Zeitwerk::Registry.loaders.each do |loader|
      paths.merge! loader.autoloads
    end

    paths.each do |path, const|
      begin
        const.join('::').constantize
      rescue NameError => e
        puts path
      end
    end
  end
end
