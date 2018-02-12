AMA_CONFIG = YAML.load(ERB.new(File.read("#{::Rails.root}/config/amazon.yml")).result)[::Rails.env]

