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

%w(checkinstall fakeroot automake autoconf gcc g++ git make).each do |pkg|
  package pkg do
    action :upgrade
  end
end

git source_code_location do
   repository node[:bfd][:repo][:url]
   revision node[:bfd][:repo][:sha]
   action :sync
   not_if { ::File.exist?(target_filepath) }
end

bash 'buildtools_bfd' do
  cwd source_code_location
  code './autogen.sh'
  action :run
  not_if { ::File.exist?(target_filepath) }
end

bash 'configure_bfd' do
  cwd source_code_location
  code './configure --prefix=/usr/local'
  action :run
  not_if { ::File.exist?(target_filepath) }
end

bash 'make_bfd' do
  cwd source_code_location
  code 'make'
  action :run
  not_if { ::File.exist?(target_filepath) }
end

bash 'build_bfd_package' do
  dependencies_str =
    if node[:bfd][:package][:dependencies]
      "--requires #{node[:bfd][:package][:dependencies]}"
    else
      ""
    end
  cwd source_code_location
  user 'root'
  group 'root'
  code 'checkinstall -D ' \
    "  --pkgname #{node[:bfd][:package][:short_name]} " \
    "  --pkgversion #{node[:bfd][:version]}" \
    "  --pkgrelease #{node[:bfd][:release]}" \
    "  -A #{node[:bfd][:arch]}"
  umask 0002
  not_if { ::File.exist?(target_filepath) }
  action :run
end

bash 'copy_bfd_package' do
  cwd source_code_location
  code "/usr/bin/install -m 444 " \
    "#{node[:bfd][:package][:name]} #{target_filepath}"
  not_if { ::File.exist?(target_filepath) }
  action :run
end

dpkg_package 'openbfdd' do
  action :install
  source target_filepath
end
