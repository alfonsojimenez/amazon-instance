class Project
  def self.load(name, environment, config_dir)
    config = nil
    filename = config_dir+'projects/'+name+'.yml'

    if File.exist?(filename)
      File.open(filename) do |content|
        config_environments = YAML::load(content)
        
        if !config_environments[environment].nil?
          config = config_environments[environment]
        else
          raise 'Invalid environment name: '+environment
        end
      end
    else
      raise 'File: '+name+'.yml does not exist'
    end
    
    config
  end
  
  def self.list_available_projects(config_dir)
    Dir.foreach(pathname) do |file|
      puts file
    end
  end
end