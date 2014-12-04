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
        "include keymaster\nuser{'tester': home => '/home/tester', gid => 'tester'}"
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
        it { should contain_ssh_authorized_key('tester@test.example.org').with(
          'ensure'  => 'present',
          'user'    => 'tester',
          'type'    => 'ssh-rsa',
          'key'     => 'THISISAFAKERSAHASH'
        ) }
        it { should contain_ssh_authorized_key('tester@test.example.org').without('options') }
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
        it { should contain_ssh_authorized_key('tester@test.example.org').with(
          'options' => '--these --are --options'
        ) }
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
