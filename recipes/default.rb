#
# Cookbook Name:: bfd
# Recipe:: default
#
# Copyright (C) 2016 Bloomberg Finance L.P.
#

if node[:bfd][:package][:source]
  source_uri = URI.parse(node[:bfd][:package][:source])

  #
  # If the parsed source URI has a scheme, and that scheme is not
  # file:///, then this is a remote file and we should instantiate a
  # remote_file resource.
  #
  # If there's no scheme, assume the source is already a local file.
  #
  if source_uri.scheme && source_uri.scheme != 'file'
    output_directory =
      ::File.join(Chef::Config[:file_cache_path], 'bfd')

    local_file_path =
      ::File.join(output_directory, ::File.basename(source_uri.path))

    directory output_directory do
      mode 0755
    end

    remote_file local_file_path do
      source source_uri.to_s
      mode 0644
    end
  else
    local_file_path = source_uri.path
  end

  dpkg_package node[:bfd][:package][:short_name] do
    source local_file_path
  end
else
  package node[:bfd][:package][:short_name] do
    action :upgrade
  end
end

template "bfdd-beacon upstart config" do
  path "/etc/init/bfdd-beacon.conf"
  source "bfdd-beacon.conf.erb"
  owner "root"
  group "root"
end

file "bfdd-beacon upstart defaults" do
  path "/etc/default/bfdd-beacon"
  content <<-EOH
#{"CONTROL=" + node[:bfd][:service][:control] if node[:bfd][:service][:control]}
#{"LISTEN=" + node[:bfd][:service][:listen] if node[:bfd][:service][:listen]}
EOH
  owner "root"
  group "root"
  only_if { node[:bfd][:service][:control] or node[:bfd][:service][:listen] }
  notifies :restart, "service[bfdd-beacon]"
end

service "bfdd-beacon" do
  provider Chef::Provider::Service::Upstart
  supports :status => true
  action [:start]
end
