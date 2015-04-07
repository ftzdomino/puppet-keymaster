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
        "include keymaster\nKeymaster::X509::Cert::Generate <| |>\nKeymaster::X509::Cert::Deploy <| |>"
      end
      describe 'with minimum parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :country      => 'NZ',
            :commonname   => 'test.example.org',
            :organization => 'Test Example Organization',
          }
        end
        it { should contain_keymaster__x509__cert__generate('test.example.org').with(
          'ensure'       => 'present',
          'country'      => 'NZ',
          'commonname'   => 'test.example.org',
          'organization' => 'Test Example Organization',
          'force'        => false,
          'days'         => '365',
          'tag'          => 'test.example.org'
        ) }
      end
      describe 'when absent' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :ensure       => 'absent',
            :country      => 'NZ',
            :commonname   => 'test.example.org',
            :organization => 'Test Example Organization',
          }
        end
        it { should contain_keymaster__x509__cert__generate('test.example.org').with(
          'ensure' => 'absent',
        ) }
      end
      describe 'customising certificate generation and content' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :ensure       => 'absent',
            :country      => 'NZ',
            :commonname   => 'test.example.org',
            :organization => 'Test Example Organization',
            :state        => 'plasma',
            :locality     => 'above',
            :aliases      => ['first','second','third'],
            :email        => 'test@example.com',
            :days         => '790',
            :password     => 'badbadpassword',
            :force        => true,
          }
        end
        it { should contain_keymaster__x509__cert__generate('test.example.org').with(
          'ensure'       => 'absent',
          'country'      => 'NZ',
          'commonname'   => 'test.example.org',
          'organization' => 'Test Example Organization',
          'force'        => true,
          'days'         => '790',
          'state'        => 'plasma',
          'locality'     => 'above',
          'aliases'      => ['first','second','third'],
          'email'        => 'test@example.com',
          'password'     => 'badbadpassword',
          'tag'          => 'test.example.org'
        ) }
        it { should contain_keymaster__x509__cert__deploy('test.example.org').with_tag('test.example.org')}
        it { should contain_keymaster__x509__key__deploy('test.example.org').with_tag('test.example.org')}
      end
    end
  end
end
