#
# Cookbook Name:: bfd
# Attribute:: default
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#

default[:bfd][:repo][:url] = 'https://github.com/dyninc/OpenBFDD.git'
default[:bfd][:repo][:sha] = '895cfb523bb96b3ef199fc5916578482ccd528ee'
default[:bfd][:version] = '0.5.3'
default[:bfd][:package][:short_name] = "openbfdd"
default[:bfd][:package][:name] = "#{node[:bfd][:package][:short_name]}_#{node[:bfd][:version]}_amd64.deb"
default[:bfd][:package][:dependencies] = nil
default[:bfd][:package][:provider] = "Chef::Provider::Package::Dpkg"
default[:bfd][:package][:source] = "#{Chef::Config[:file_cache_path]}/#{node[:bfd][:package][:name]}"
default[:bfd][:install_dir] = '/usr/local'
default[:bfd][:bin_dir] = "#{Chef::Config[:file_cache_path]}"
default[:bfd][:owner] = 'root'
default[:bfd][:group] = 'root'
# defaults to 127.0.0.1:957/958
default[:bfd][:service][:control] = nil
# defaults to 0.0.0.0:3784
default[:bfd][:service][:listen] = nil
