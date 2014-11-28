require 'spec_helper'
describe 'keymaster::openssh::key::deploy', :type => :define do
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

      end
    end
  end
end
