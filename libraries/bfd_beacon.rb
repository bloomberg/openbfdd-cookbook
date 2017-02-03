#
# Cookbook Name:: bfd
# Library:: image
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#

begin
  require 'poise'
rescue LoadError
end

class Chef
  class Resource::BfdBeacon < Resource
    include Poise

    provides(:bfd_beacon) if respond_to?(:provides)

    actions(:start)
    actions(:stop)

    attribute(:control, kind_of: [String, Array], default: nil)
    attribute(:listen, kind_of: [String, Array], default: nil)

  end

  class Provider::BfdBeacon < Provider
    include Poise

    def action_start 
      bfd_ctrl = "#{node[:bfd][:install_dir]}/bin/bfdd-control"
      bfd_beacon = "#{node[:bfd][:install_dir]}/bin/bfdd-beacon"

      controls = ""
      controls = " " + new_resource.control.join("--control=") if new_resource.control.is_a?(Array)
      controls = " " + "--control=" + new_resource.control if new_resource.control.is_a?(String)

      listeners = ""
      listeners = " " + new_resource.listen.join("--listen=") if new_resource.listen.is_a?(Array)
      listeners = " " + "--listen=" + new_resource.listen if new_resource.listen.is_a?(String)

      converge_by("starting BFD #{new_resource.name}") do
        notifying_block do
          bash "#{bfd_beacon}#{controls}#{listeners}"
        end
      end
    end

    def action_stop
      bfd_ctrl = "#{node[:bfd][:install_dir]}/bin/bfdd-control"
      bfd_beacon = "#{node[:bfd][:install_dir]}/bin/bfdd-beacon"

      converge_by("stopping BFD #{new_resource.name}") do
        notifying_block do
          bash "#{bfd_ctrl} stop"
        end
      end
    end

  end
end
