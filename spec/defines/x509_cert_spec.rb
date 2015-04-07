require 'spec_helper'
describe 'keymaster::x509::cert', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    describe 'with default keymaster and realising stored resources' do
      let :pre_condition do
        "include keymaster\nKeymaster::X509::Cert::Generate <| |>"
      end
      describe 'with minimum parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :country      => 'nz',
            :commonname   => 'test.example.org',
            :organization => 'Test Example Organization',
          }
        end
        it { should contain_keymaster__x509__cert__generate('test.example.org').with(
          'ensure'       => 'present',
          'country'      => 'nz',
          'commonname'   => 'test.example.org',
          'organization' => 'Test Example Organization',
          'force'        => false,
          'days'         => '365',
          'tag'          => 'test.example.org'
        ) }
      end
    end
  end
end
