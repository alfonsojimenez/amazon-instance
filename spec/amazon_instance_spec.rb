$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'amazon-instance'

describe 'AmazonInstance' do
  before :all do
    @config_dir = File.join(File.dirname(__FILE__), 'fixtures/')
    @project_name = 'example'
  end
  
  context 'When an instance is created' do
    it 'with a valid environment name' do
      instance = AmazonInstance.new('test', @project_name, @config_dir)
      instance.environment.should == 'test'
      
      instance = AmazonInstance.new('qa', @project_name, @config_dir)
      instance.environment.should == 'qa'
      
      instance = AmazonInstance.new('prod', @project_name, @config_dir)
      instance.environment.should == 'prod'
      
      instance = AmazonInstance.new('dev', @project_name, @config_dir)
      instance.environment.should == 'dev'
    end
    
    it 'with an invalid environment name should raise an exception' do
      expect {AmazonInstance.new('xxx', @project_name, @config_dir)}.to raise_error('Invalid environment name: xxx')
      expect {AmazonInstance.new('yyy',@project_name, @config_dir)}.to raise_error('Invalid environment name: yyy')
    end
    
    it 'with an invalid project name should raise an exception' do
      expect {AmazonInstance.new('dev', 'invalid_config', @config_dir)}.to raise_error('File: invalid_config.yml does not exist')
    end
  end
  
  context 'When launching an instance' do
    it 'should return the instance host' do
      ec2 = mock('AmazonEC2')
      ec2.should_receive(:valid_group?).with(any_args()).and_return(true)
      ec2.should_receive(:launch_instance).with(any_args()).and_return('amazon-host.com')
      ec2.should_receive(:sleep_till_ssh_is_open).with(any_args()).and_return(true)
      
      instance = AmazonInstance.new('test', @project_name, @config_dir)
      instance.launch(ec2).should == 'amazon-host.com'
    end
  end
end