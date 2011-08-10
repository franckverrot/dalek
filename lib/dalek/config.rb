module Dalek
  class Config
    def self.read(path)
      YAML::load(ERB.new(File.read(path)).result)
    end
  end
end
