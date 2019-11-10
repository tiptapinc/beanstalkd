#
# Cookbook Name:: beanstalkd
# Recipe:: default
#
# Copyright (c) 2016, David Joos
#

package 'beanstalkd' do
  action :upgrade
end

case node['platform']
when 'debian', 'ubuntu'
  template_path = '/etc/default/beanstalkd' # templates/ubuntu
else
  template_path = '/etc/sysconfig/beanstalkd' # templates/default
end

template template_path do
  source 'beanstalkd.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :opts => node['beanstalkd']['opts'],
    :listen_addr => node['beanstalkd']['listen_addr'],
    :listen_port => node['beanstalkd']['listen_port'],
    :start_during_boot => node['beanstalkd']['start_during_boot']
  )
  notifies :restart, 'service[beanstalkd]'
end

service 'beanstalkd' do
  start_command '/etc/init.d/beanstalkd start'
  stop_command '/etc/init.d/beanstalkd stop'
  status_command '/etc/init.d/beanstalkd status'
  supports [:start, :stop, :status]
  # starts the service if it's not running and enables it to start at system boot time
  action [:enable, :start]
end
