# Chef Cookbook
[![CI](https://github.com/codenamephp/chef.cookbook.sshKeys/actions/workflows/ci.yml/badge.svg)](https://github.com/codenamephp/chef.cookbook.sshKeys/actions/workflows/ci.yml)

## Usage

Just use this in your wrapper cookbook and use the resources any way you see fit.

## Resources

### local_copy

The `codenamephp_ssh_keys_local_copy` resources copies the key pair from a local path to the user .ssh folder and makes sure it has the correct permissions. The resources makes some assumptions:

- The user the keys will be copied to exists. If the user doesn't exist the resource will error. Use a only_if/not_if guard if necessary.
- The public key is in the same location as the private key and just has the .pub extension
- The private key will be copied to ~/.ssh/ with the same file name
- The public key will aso be copied to ~/.ssh/ and will get the same filename as the private key with the .pub extension

If any of these assumptions differ from what you need make sure to set the appropriate properties.

#### Actions
- `:installs`: Copies both keys (if they exist) to the user .ssh folder

#### Properties
- `user`: The user name the keys will belong to
- `private_key_source`: The path of the private key file
- `private_key_target`: The path where the private key will be copied to, defaults to `~/.ssh/original_filename`
- `public_key_source`: The path of the public key file, defaults to `private_key_source.pub`
- `public_key_target`: The path where the public key will be copied to, defaults to `private_key_target.pub`

#### Examples
```ruby
# Minimal properties
codenamephp_ssh_keys_local_copy 'Copy keys' do
  user 'test'
  private_key_source '/var/workspace/id_rsa'
end

# With custom paths
codenamephp_ssh_keys_local_copy 'Copy keys' do
  user 'test'
  private_key_source '/var/workspace/id_rsa'
  private_key_target '/home/test/.not-ssh/id_rsa'
  public_key_source '/var/public/some_key.pub'
  public_key_target '/tmp/not/sure/why.pub'
end
```

#### Why?

I like to use VMs as my local workstations I create with Vagrant + Chef. My base workspace folder (containing the chef repo and other common stuff) is mounted to /var/workspace using vagrant. So I use this as a simple way to install the ssh keys without any sophisticated vault solution and still don't have my keys to leave my local system.
