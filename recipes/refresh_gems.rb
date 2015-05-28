file '/root/.gemrc' do
  content <<-EOF
---
:ssl_verify_mode: 0
:backtrace: false
:benchmark: false
:bulk_threshold: 1000
:sources:
- http://rubygems.org/
:update_sources: true
:verbose: true
EOF
  action :create
  notifies :run, 'ruby_block[refresh_gemrc]', :immediately
end

ruby_block 'refresh_gemrc' do
  action :nothing
  block do
    Gem.configuration = Gem::ConfigFile.new []
  end
end
