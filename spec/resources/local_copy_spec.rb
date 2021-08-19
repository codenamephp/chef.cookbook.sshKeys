require 'spec_helper'

describe 'codenamephp_ssh_keys_local_copy' do
  platform 'debian' # https://github.com/chefspec/chefspec/issues/953

  step_into :codenamephp_ssh_keys_local_copy

  context 'Install with minimal properties' do
    before(:example) do
      allow(File).to receive(:expand_path).and_call_original
      allow(File).to receive(:expand_path).with('~some user').and_return('/home/some-user')
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/some/private/key').and_return(true)
      allow(File).to receive(:exist?).with('/some/private/key.pub').and_return(true)
    end

    recipe do
      codenamephp_ssh_keys_local_copy 'Copy ssh key' do
        user 'some user'
        private_key_source '/some/private/key'
      end
    end

    it 'should create the folder for both keys' do
      expect(chef_run).to create_directory('Create directory for private key').with(
        path: '/home/some-user/.ssh',
        owner: 'some user',
        group: 'some user',
        mode: '0700'
      )
      expect(chef_run).to create_directory('Create directory for public key').with(
        path: '/home/some-user/.ssh',
        owner: 'some user',
        group: 'some user',
        mode: '0700'
      )
    end

    it 'should create both keys' do
      expect(chef_run).to create_remote_file('Copy private key').with(
        source: 'file:///some/private/key',
        path: '/home/some-user/.ssh/key',
        owner: 'some user',
        group: 'some user',
        mode: '0600',
        sensitive: true
      )
      expect(chef_run).to create_remote_file('Copy public key').with(
        source: 'file:///some/private/key.pub',
        path: '/home/some-user/.ssh/key.pub',
        owner: 'some user',
        group: 'some user',
        mode: '0640',
        sensitive: true
      )
    end

    it 'will do nothing if files do not exist' do
      allow(File).to receive(:exist?).with('/some/private/key').and_return(false)
      allow(File).to receive(:exist?).with('/some/private/key.pub').and_return(false)

      expect(chef_run).to_not create_directory('Create directory for private key')
      expect(chef_run).to_not create_directory('Create directory for public key')
      expect(chef_run).to_not create_remote_file('Copy private key')
      expect(chef_run).to_not create_remote_file('Copy public key')
    end
  end
end
