#
# Cookbook Name:: bfd
# Recipe:: default
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#

target_filepath = "#{node[:bfd][:bin_dir]}/#{node[:bfd][:package][:name]}"
owner = node[:bfd][:owner]
group = node[:bfd][:group]
source_code_location = "#{Chef::Config[:file_cache_path]}/bfd"

%w(ruby1.9.1-dev).each do |pkg|
  package pkg
end

gem_package 'fpm' do
  gem_binary '/usr/bin/gem'
  action :install
end

%w(automake autoconf gcc git make).each do |pkg|
  package pkg do
    action :install
  end
end

git source_code_location do
   repository node[:bfd][:repo][:url]
   revision node[:bfd][:repo][:sha]
   action :sync
   notifies :run, 'bash[buildtools_bfd]', :immediately
   notifies :run, 'bash[configure_bfd]', :immediately
   notifies :run, 'bash[make_bfd]', :immediately
   notifies :run, 'bash[build_bfd_package]', :immediately
   not_if { ::File.exist?(target_filepath) }
end

bash 'buildtools_bfd' do
  cwd source_code_location
  code './autogen.sh'
  action :nothing
end

bash 'configure_bfd' do
  cwd source_code_location
  code "./configure --prefix=#{node[:bfd][:bin_dir]}/bfd-build"
  action :nothing
end

bash 'make_bfd' do
  cwd source_code_location
  code 'make && make install'
  action :nothing
end

bash 'build_bfd_package' do
  dependencies_str = node[:bfd][:package][:dependencies] ? "-d #{node[:bfd][:package][:dependencies]} --no-auto-depends" : "--no-depends --no-auto-depends"
  cwd "#{node[:bfd][:bin_dir]}/bfd-build"
  user 'root'
  group 'root'
  code %Q{
    fpm -s dir -t deb --prefix /usr/local \
        -n #{node[:bfd][:package][:short_name]} \
        -v #{node[:bfd][:version]} \
        #{dependencies_str} \
        * && \
    mv #{node[:bfd][:package][:name]} #{target_filepath}
  }
  umask 0002
  not_if { ::File.exist?(target_filepath) }
  action :nothing
end
