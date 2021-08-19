unified_mode true

property :user, String, description: 'The user the key will belong to'
property :private_key_source, String, description: 'The local path to the private key that will be copied'
property :private_key_target, String, default: lazy { ::File.expand_path("~#{user}") + "/.ssh/#{::File.basename(private_key_source)}" }, description: 'The target location to where the private key will be copied to'
property :public_key_source, String, default: lazy { "#{private_key_source}.pub" }, description: 'The local path to the public key file that will be copied'
property :public_key_target, String, default: lazy { "#{private_key_target}.pub" }, description: 'The target location where the public key will be copied to'

action :install do
  {
    new_resource.private_key_source => { type: 'private', target: new_resource.private_key_target, mode: '0600' },
    new_resource.public_key_source => { type: 'public', target: new_resource.public_key_target, mode: '0640' },
  }.each do |source, target_info|
    directory "Create directory for #{target_info[:type]} key" do
      path lazy { ::File.dirname(target_info[:target]) }
      owner new_resource.user
      group new_resource.user
      mode '0700'
      only_if { ::File.exist?(source) }
    end

    remote_file "Copy #{target_info[:type]} key" do
      source "file://#{source}"
      path target_info[:target]
      owner new_resource.user
      group new_resource.user
      mode target_info[:mode]
      sensitive true
      only_if { ::File.exist?(source) }
    end
  end
end
