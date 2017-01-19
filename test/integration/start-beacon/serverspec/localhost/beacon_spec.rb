require 'spec_helper'

describe package('openbfdd') do
  it { should be_installed }
end

describe service('bfdd-beacon') do
  it { should be_running }
end

describe process("bfdd-beacon") do
  its(:user) { should eq "root" }
  its(:args) { should match /--nofork --control=127.0.0.1:1001 --listen=127.0.0.1\b/ }
end

describe port(1001) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe port(3784) do
  it { should be_listening.on('127.0.0.1').with('udp') }
end
