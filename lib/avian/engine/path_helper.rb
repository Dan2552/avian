module Avian
  module PathHelper
    def self.resource_path(*parts)
      File.join(Platform.resources_dir, *parts)
    end
  end
end
