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
    describe 'with default keymaster' do
      let :pre_condition do
        "include keymaster"
      end
      describe 'with no parameters' do
        let :title do
          'tester@test.example.org'
        end
        it { should contain_class('keymaster::params') }
        it { should contain_file('tester@test.example.org_dir').with(
          'ensure' => 'directory',
          'path'   => '/var/lib/keymaster/openssh/tester_at_test.example.org',
          'mode'   => '0644',
          'owner' => 'puppet',
          'group' => 'puppet'
        ) }
        it { should contain_file('tester@test.example.org_key').with(
          'ensure' => 'present',
          'path'   => '/var/lib/keymaster/openssh/tester_at_test.example.org/key',
          'mode'   => '0600',
          'owner' => 'puppet',
          'group' => 'puppet'
        ) }
        it { should contain_file('tester@test.example.org_pub').with(
          'ensure' => 'present',
          'path'   => '/var/lib/keymaster/openssh/tester_at_test.example.org/key.pub',
          'mode'   => '0600',
          'owner' => 'puppet',
          'group' => 'puppet'
        ) }
        it { should contain_exec('Create key tester@test.example.org: rsa, 2048 bits').with(
          'command' => 'ssh-keygen -t rsa -b 2048 -f /var/lib/keymaster/openssh/tester_at_test.example.org/key -C \'rsa 2048\' -N \'\'',
          'user'    => 'puppet',
          'group'   => 'puppet',
          'creates' => '/var/lib/keymaster/openssh/tester_at_test.example.org/key',
          'before'  => [ 'File[tester@test.example.org_key]', 'File[tester@test.example.org_pub]' ],
          'require' => 'File[tester@test.example.org_dir]'
        ) }
        it { should_not contain_exec('Revoke previous key tester@test.example.org: force=true') }
      end
      describe 'when specifying a DSA key' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :keytype => 'dsa',
            :length  => '4096'
          }
        end
        it { should contain_exec('Create key tester@test.example.org: dsa, 1024 bits').with(
          'command' => "ssh-keygen -t dsa -b 1024 -f /var/lib/keymaster/openssh/tester_at_test.example.org/key -C 'dsa 1024' -N ''"
        ) }
      end
      describe 'when forcing key replacement' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :force => true
          }
        end
        it { should contain_exec('Revoke previous key tester@test.example.org: force=true').with(
          'command' => "rm /var/lib/keymaster/openssh/tester_at_test.example.org/key /var/lib/keymaster/openssh/tester_at_test.example.org/key.pub",
          'before'  => 'Exec[Create key tester@test.example.org: rsa, 2048 bits]'
        ) }
      end
      # There should be tests for maxage and mindate... which could be tricky
    end
  end
end
