require 'AWS'
require 'socket'
require 'timeout'

class AmazonEC2
  def initialize(access_key, secret_key, ec2_server, elb_server)
    @ec2 = AWS::EC2::Base.new(:access_key_id     => access_key,
                              :secret_access_key => secret_key,
                              :server            => ec2_server)
    @elb = AWS::ELB::Base.new(:access_key_id     => access_key,
                              :secret_access_key => secret_key,
                              :server            => elb_server)
  end
  
  def launch_instance(environment, config, config_dir) 
    config[:base64_encoded] = true
    
    if !config[:on_boot].nil?
      File.open(config_dir+'on-boot/'+config[:on_boot]) do |content|
        config[:user_data] = content.read.gsub!('{environment}', environment)
      end
    end

    instance = @ec2.run_instances(config.to_hash)
    
    instance_id = instance['instancesSet']['item'].first['instanceId']

    if config[:load_balancer]
      attach_instance_to_load_balancer(instance_id, config[:load_balancer])
    end

    host_by_instance(instance_id)
  end
  
  def valid_group?(group_name)
    valid_group = false
    
    @ec2.describe_security_groups['securityGroupInfo']['item'].each do |group|
      valid_group = true if group['groupName'] == group_name
    end

    valid_group
  end

  def host_by_instance(instance_id)
    host = nil

    while host == nil do
      instances = @ec2.describe_instances({:instance_id => instance_id})
      host = instances['reservationSet']['item'].first['instancesSet']['item'].first['dnsName']
      sleep 2
    end
    
    host
  end
  
  def attach_instance_to_load_balancer(instance_id, load_balancer_name)
    @elb.register_instances_with_load_balancer(:load_balancer_name => load_balancer_name,
                                               :instances => [instance_id])
  end
  
  def sleep_till_ssh_is_open(host)
    while ssh_open?(host) do
      sleep(3)
    end
  end
  
  def ssh_open?(host)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(host, 22)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false
  end
end