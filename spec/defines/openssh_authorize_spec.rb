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
    describe 'with default keymaster' do
      let :pre_condition do
        "include keymaster\nuser{'tester': home => '/home/tester}"
      end
      describe 'with minimum parameters' do
        let :title do
          'user@test.example.org'
        end
        let :params do
          {
            :user   => 'tester'
          }
        end
        # some parameters (type and key) can not be tested without fixtures in place
        it { should contain_ssh_authorized_key('user@test.example.org').with(
          'ensure'  => 'present',
          'user'    => 'tester'
        ) }
        it { should contain_ssh_authorized_key('user@test.example.org').without('options') }
      end
      describe 'when setting options' do
        let :title do
          'user@test.example.org'
        end
        let :params do
          {
            :user    => 'tester',
            :options => '--these --are --options'
          }
        end
        # some parameters (type and key) can not be tested without fixtures in place
        it { should contain_ssh_authorized_key('user@test.example.org').with(
          'options' => '--these --are --options'
        ) }
      end
      describe 'when ensure is absent' do
        let :title do
          'user@test.example.org'
        end
        let :params do
          {
            :user   => 'tester',
            :ensure => 'absent'
          }
        end
        it { should contain_ssh_authorized_key('user@test.example.org').with_ensure('absent')}
      end
    end
  end
end
