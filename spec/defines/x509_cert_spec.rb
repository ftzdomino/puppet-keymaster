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
        "include keymaster\nKeymaster::X509::Cert::Generate <| |>\nKeymaster::X509::Cert::Deploy <| |>\nKeymaster::X509::Key::Deploy <| |>"
      end
      describe 'with minimum parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :commonname   => 'test.example.org',
          }
        end
        it { should contain_keymaster__x509__cert__generate('test.example.org').with(
          'ensure'       => 'present',
          'commonname'   => 'test.example.org',
          'days'         => '365',
          'tag'          => 'test.example.org'
        ) }
        it { should contain_keymaster__x509__cert__deploy('test.example.org').with_tag('test.example.org')}
        it { should contain_keymaster__x509__key__deploy('test.example.org').with_tag('test.example.org')}
        it { should contain_keymaster__x509__deploy('test.example.org').with(
          'ensure'      => 'present',
          'cert_path'   => nil,
          'key_path'    => nil,
          'type'        => nil,
          'owner'       => nil,
          'group'       => nil,
          'deploy_cert' => true,
          'deploy_key'  => true,
        ) }
      end
      describe 'when absent' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :ensure       => 'absent',
            :commonname   => 'test.example.org',
          }
        end
        it { should contain_keymaster__x509__cert__generate('test.example.org').with(
          'ensure' => 'absent',
        ) }
        it { should contain_keymaster__x509__deploy('test.example.org').with(
          'ensure'      => 'absent',
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
          }
        end
        it { should contain_keymaster__x509__cert__generate('test.example.org').with(
          'ensure'       => 'absent',
          'country'      => 'NZ',
          'commonname'   => 'test.example.org',
          'organization' => 'Test Example Organization',
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
    describe 'when only deploying certificate' do
      let :title do
        'test.example.org'
      end
      let :params do
        {
          :ensure       => 'present',
          :commonname   => 'test.example.org',
          :deploy_cert  => true,
          :deploy_key   => false,
        }
      end
      it { should contain_keymaster__x509__deploy('test.example.org').with(
        'ensure'      => 'present',
        'deploy_cert' => true,
        'deploy_key'  => false,
      ) }
    end
    describe 'when only deploying the private key' do
      let :title do
        'test.example.org'
      end
      let :params do
        {
          :ensure       => 'present',
          :commonname   => 'test.example.org',
          :deploy_cert  => false,
          :deploy_key   => true,
        }
      end
      it { should contain_keymaster__x509__deploy('test.example.org').with(
        'ensure'      => 'present',
        'deploy_cert' => false,
        'deploy_key'  => true,
      ) }
    end
    describe 'when not deploying key or certificate' do
      let :title do
        'test.example.org'
      end
      let :params do
        {
          :ensure       => 'present',
          :commonname   => 'test.example.org',
          :deploy_cert  => false,
          :deploy_key   => false,
        }
      end
      it { should_not contain_keymaster__x509__deploy('test.example.org') }
    end
    describe 'when customising key and certificate deployment' do
      let :title do
        'test.example.org'
      end
      let :params do
        {
          :ensure       => 'present',
          :commonname   => 'test.example.org',
          :cert_path    => '/path/to/cert.crt',
          :key_path     => '/path/to/key.pem',
          :type         => 'der',
          :owner        => 'nobody',
          :group        => 'nobody'
        }
      end
      it { should contain_keymaster__x509__deploy('test.example.org').with(
          'ensure'      => 'present',
          'cert_path'   => '/path/to/cert.crt',
          'key_path'    => '/path/to/key.pem',
          'type'        => 'der',
          'owner'       => 'nobody',
          'group'       => 'nobody',
          'deploy_cert' => true,
          'deploy_key'  => true,
        ) }
    end
  end
end
