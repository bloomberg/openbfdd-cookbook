#
# Cookbook Name:: bfd
# Recipe:: default
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#

# from http://stackoverflow.com/questions/3163641/get-a-class-by-name-in-ruby
package node[:bfd][:package][:short_name] do
  source node[:bfd][:package][:source] if node[:bfd][:package][:source]
end

template "bfdd-beacon upstart config" do
  path "/etc/init/bfdd-beacon.conf"
  source "bfdd-beacon.conf.erb"
  owner "root"
  group "root"
end

service "bfdd-beacon" do
  provider Chef::Provider::Service::Upstart
  supports :status => true
  action [:start]
end
