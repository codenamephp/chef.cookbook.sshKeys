# frozen_string_literal: true

describe file('/home/test/.ssh/key') do
  it { should exist }
  it { should be_file }
  its('content') { should eq 'my private key' }
  its('group') { should eq 'test' }
  its('owner') { should eq 'test' }
  its('mode') { should cmp '0600' }
end

describe file('/home/test/.ssh/key.pub') do
  it { should exist }
  it { should be_file }
  its('content') { should eq 'my public key' }
  its('group') { should eq 'test' }
  its('owner') { should eq 'test' }
  its('mode') { should cmp '0640' }
end
