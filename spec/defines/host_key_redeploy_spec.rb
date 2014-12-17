require 'spec_helper'
describe 'keymaster::host_key::redeploy', :type => :define do
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
        "include keymaster\nkeymaster::host_key::key{'test.example.org': }"
      end
      describe 'with no parameters' do
        let :title do
          'test.example.org'
        end
        it { should compile }
        # Can not test for instanced virtual resources
      end
    end
  end
end