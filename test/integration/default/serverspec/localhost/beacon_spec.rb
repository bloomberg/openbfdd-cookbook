require 'spec_helper'

describe package('openbfdd') do
  it { should be_installed }
end

describe service('bfdd-beacon') do
  it { should be_running }
end
