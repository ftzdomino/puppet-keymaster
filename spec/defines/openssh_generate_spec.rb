require 'spec_helper'
describe 'keymaster::openssh::key::generate', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    describe 'with default gitlab' do
      let :pre_condition do
        "include keymaster"
      end
      describe 'with no parameters' do
        let :title do
          'user@test.example.org'
        end
        it { should contain_file('user@test.example.org_dir').with(
          'ensure' => 'directory',
          'path'   => '/var/lib/keymaster/openssh/user_at_test.example.org',
          'mode'   => '0644',
          'owner' => 'puppet',
          'group' => 'puppet'
        ) }
        it { should contain_file('user@test.example.org_key').with(
          'ensure' => 'present',
          'path'   => '/var/lib/keymaster/openssh/user_at_test.example.org/key',
          'mode'   => '0600',
          'owner' => 'puppet',
          'group' => 'puppet'
        ) }
        it { should contain_file('user@test.example.org_pub').with(
          'ensure' => 'present',
          'path'   => '/var/lib/keymaster/openssh/user_at_test.example.org/key.pub',
          'mode'   => '0600',
          'owner' => 'puppet',
          'group' => 'puppet'
        ) }
        it { should contain_exec('Create key user@test.example.org: rsa, 2048 bits').with(
          'command' => "ssh-keygen -t rsa -b 2048 -f /var/lib/keymaster/openssh/user_at_test.example.org/key -C 'user@test.example.org' -N ''",
          'user'    => 'puppet',
          'group'   => 'puppet',
          'creates' => '/var/lib/keymaster/openssh/user_at_test.example.org/key',
          'before'  => [ 'File[user@test.example.org_key]', 'File[user@test.example.org_pup]' ],
          'require' => 'File[user@test.example.org_dir]'
        ) }
      end
    end
  end
end
