#"
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
  class Resource::BfdSession < Resource
    include Poise

    provides(:bfd_session) if respond_to?(:provides)

    actions(:connect)
    actions(:up)
    actions(:down)
    actions(:admin)
    actions(:kill)

    attribute :local_ip, kind_of: String, required: true
    attribute :remote_ip, kind_of: String, required: true
  end

  class Provider::BfdSession < Provider
    include Poise

    def action_connect
      bfd_ctrl = "#{node[:bfd][:install_dir]}/bin/bfdd-control"
      stream_id = "local #{new_resource.local_ip} remote #{new_resource.remote_ip}"

      converge_by("BFD connection #{new_resource.name} being created") do
        bash "Touch a test file" do
          code "touch /tmp/t"
          action :run
        end
        bash "Connect #{stream_id} using bfdd-control" do
          code "#{bfd_ctrl} connect #{stream_id}"
          action :run
        end
      end
    end

    def action_kill
      bfd_ctrl = "#{node[:bfd][:install_dir]}/bin/bfdd-control"
      stream_id = "local #{new_resource.local_ip} remote #{new_resource.remote_ip}"

      converge_by("BFD session #{new_resource.name} being killed") do
        bash "Kill session #{stream_id} using bfdd-control" do
          code "#{bfd_ctrl} session #{stream_id} kill"
          action :run
        end
      end
    end

    def action_down
      state_change("down")
    end

    def action_up
      state_change("up")
    end

    def action_admin
      state_change("admin")
    end

    def self.verify_stream_status(stream_id, desired_state, bfd_ctrl)
      true
    end
    def XXXself_verify_stream_status(stream_id, desired_state, bfd_ctrl) # XXX disabled due to routers not listening
      verify = Mixlib::ShellOut.new("#{bfd_ctrl} status #{stream_id} level 0")
      verify.run_command
      # Expected output
      # id=2 
      # local=100.82.16.121 
      # remote=100.82.16.65 
      # state=Up
      kv_pairs = verify.stdout.split("\n")
      kvs = kv_pairs.map do |kv|
        (key, value) = kv.strip.split('=',2)
        key = key.strip.downcase
        value = value.strip.downcase
        [key, value]
      end
      kv = kvs.select { |key, value| key == "state" }
      raise "Did not get key 'state'; got:\n#{kvs}" if kv.length != 1
      (key, value) = kv.first
      Chef::Log.warn("Unable to get BFD state!") if key != "state"
      if value != desired_state
        raise "BFD session #{stream_id} still #{value}!"
      end
    end

    def state_change(state)
      bfd_ctrl = "#{node[:bfd][:install_dir]}/bin/bfdd-control"
      stream_id = "local #{new_resource.local_ip} remote #{new_resource.remote_ip}"
      converge_by("BFD connection #{new_resource.name} being brought #{state}") do
        notifying_block do
          bash "transition #{stream_id} to state #{state} using bfdd-control" do
            code "#{bfd_ctrl} session #{stream_id} state #{state}"
            action :run
          end
          ruby_block "verify #{stream_id}" do
            block do
              Chef::Provider::BfdSession.verify_stream_status(stream_id, state, bfd_ctrl)
            end
          end
        end
      end
    end
  end
end
