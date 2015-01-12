require 'spec_helper'
describe 'keymaster::host_key::key::deploy', :type => :define do
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
          'test.example.org'
        end
        it { should contain_class('keymaster::params') }
        it { should contain_ssh__server__host_key('test.example.org').with(
          'private_key_content' => "-----BEGIN RSA PRIVATE KEY-----THISISAFAKERSAHASH-----END RSA PRIVATE KEY-----\n",
          'public_key_content'  => 'ssh-rsa THISISAFAKERSAHASH test.example.org'
        ) }
      end
      describe 'when ensure is absent' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :ensure   => 'absent',
          }
        end
        it { should_not contain_ssh__server__host_key('test.example.org') }
      end
      describe 'when key source files not present' do
        let :title do
          'some.other.org'
        end
        it { should contain_notify('host_key_some.other.org_did_not_run').with(
          'message' => 'Can\'t read public key /var/lib/keymaster/host_key/some.other.org/key.pub'
        ) }
      end
    end
  end
end
