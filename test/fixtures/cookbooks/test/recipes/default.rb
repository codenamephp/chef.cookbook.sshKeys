# frozen_string_literal: true

group 'test'

user 'test' do
  group 'test'
  manage_home true
  shell '/bin/bash'
end

file '/tmp/key' do
  content 'my private key'
end

file '/tmp/key.pub' do
  content 'my public key'
end

codenamephp_ssh_keys_local_copy 'Copy ssh keys' do
  user 'test'
  private_key_source '/tmp/key'
end
