require 'spec_helper'
describe 'keymaster::openssh::key::authorized_key', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    def with_keyfile
      File.stubs(:exists).with('/var/lib/keymaster/openssh/tester_at_test.example.org/key.pub').returns(true)
      File.stubs(:read).with('/var/lib/keymaster/openssh/tester_at_test.example.org/key.pub').returns('rsa test foo@baa')
      File.stubs(:binread).with('/var/lib/keymaster/openssh/tester_at_test.example.org/key.pub').returns('rsa test foo@baa')
    end
    describe 'with default keymaster' do
      let :pre_condition do
        "include keymaster\nuser{'tester': home => '/home/tester'}"
      end
      describe 'with minimum parameters' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :user   => 'tester'
          }
        end
        it 'should retrieve contents from stored public key' do
          with_keyfile do
            should contain_ssh_authorized_key('tester@test.example.org').with(
              'ensure'  => 'present',
              'user'    => 'tester'
            )
            should contain_ssh_authorized_key('tester@test.example.org').without('options')
          end
        end
      end
      describe 'when setting options' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :user    => 'tester',
            :options => '--these --are --options'
          }
        end
        # some parameters (type and key) can not be tested without fixtures in place
        it 'should retrieve contents from stored public key' do
          with_keyfile do
            should contain_ssh_authorized_key('tester@test.example.org').with(
              'options' => '--these --are --options'
            )
          end
        end
      end
      describe 'when ensure is absent' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :user   => 'tester',
            :ensure => 'absent'
          }
        end
        it { should contain_ssh_authorized_key('tester@test.example.org').with_ensure('absent')}
      end
    end
  end
end
