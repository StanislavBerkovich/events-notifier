require 'yaml'

class Config
  def initialize(yaml_file)
    @config = YAML.load_file(yaml_file)
  end

  def discord_bot_token
    @config['discord_bot_token']
  end

  def servers
    @config['servers'].split(',').map { |s| s.strip }
  end

  def mongo_url
    @config['mongo_url']
  end
end
