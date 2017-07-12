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

template '/etc/default/bfdd-beacon' do
  source 'bfdd-beacon.defaults.erb'
  owner 'root'
  group 'root'
  variables({
             control: node[:bfd][:service][:control],
             listen: node[:bfd][:service][:listen]
            })
  notifies :restart, 'service[bfdd-beacon]'
end

if node[:lsb][:id] == 'Ubuntu' && node[:lsb][:release].to_f <= 14.04
  template 'bfdd-beacon upstart config' do
    path '/etc/init/bfdd-beacon.conf'
    source 'bfdd-beacon.conf.erb'
    owner 'root'
    group 'root'
  end
else
  template 'bfdd-beacon systemd config' do
    path '/etc/systemd/system/bfdd-beacon.service'
    source 'bfdd-beacon.service.erb'
    owner 'root'
    group 'root'
    variables({
               bfdd_beacon_path:
                 File.join(node[:bfd][:install_dir],'/bin/bfdd-beacon')
              })
  end
end

service 'bfdd-beacon' do
  supports status: true
  action [:start]
  if node[:lsb][:id] == 'Ubuntu' && node[:lsb][:release].to_f <= 14.04
    provider Chef::Provider::Service::Upstart
  end
end
