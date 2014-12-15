require 'spec_helper'
describe 'keymaster::openssh::authorize', :type => :define do
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
        "include keymaster\nkeymaster::openssh::key{'tester@test.example.org': }\nuser{'tester': home => '/home/tester', gid => 'tester'}"
      end
      # rspec-puppet does not yet test instanced virtual resources
      describe 'without a defined key' do
        let :title do
          'no@key.defined'
        end
        let :params do
          {
            :user => 'tester'
          }
        end
        it { should compile }
      end
      describe 'with an undefined user' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :user => 'nobody'
          }
        end
        it { should raise_error(Puppet::Error, /The user 'nobody' has not been defined in Puppet/) }
      end
      describe 'with no parameters' do
        let :title do
          'tester@test.example.org'
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Authorize/) }
      end
      describe 'with only a options string' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :options => '--these --are --options'
          }
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Authorize/) }
      end
      describe 'with only an ensure' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :ensure => 'present'
          }
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Authorize/) }
      end
      describe 'with ensure and options, but no user' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :ensure => 'present',
            :options => '--these --are --options'
          }
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Authorize/) }
      end
    end
  end
end