require 'rubygems'

require File.dirname(__FILE__)+'/amazon-instance/project'
require File.dirname(__FILE__)+'/amazon-instance/amazon-ec2'
  
class AmazonInstance
  attr_accessor :config
  attr_accessor :config_dir
  attr_accessor :environment
  attr_accessor :project
  attr_accessor :verbose
  
  def initialize(environment, project, config_dir, verbose=false)
    @config = load_general_config(config_dir)
    
    @config_dir = config_dir
    @environment = environment
    @verbose = verbose
    
    @project = Project::load(project, environment, config_dir)
  end
  
  def launch(ec2=nil)
    ec2 = AmazonEC2.new(@config['access_key_id'],
                        @config['secret_key_id'],
                        URI.parse(@config['ec2_zone_url']).host) if ec2.nil?

    group = @project[:security_group]
    
    raise 'Invalid security group: '+group unless ec2.valid_group?(group)

    print_message('Creating instance') if @verbose
    host = ec2.launch_instance(@environment, @project, @config_dir)
    print_message('Instance created', :ok) if @verbose

    # Wait till ssh port is open
    print_message('Checking SSH port') if @verbose
    ec2.sleep_till_ssh_is_open(host)
    print_message('SSH port open: '+host, :ok) if @verbose
    
    host
  end

  private
  def load_general_config(config_dir)
    config = nil

    File.open(config_dir+'general.yml') do |content|
      config = YAML::load(content.read)
    end
    
    config
  end
  
  def print_message(message, level=:info)
    colours = {:info => 33, :error => 31, :ok => 32}
    
    puts "\e[#{colours[level]}m[#{level.to_s}] #{message}\e[0m"
  end
end