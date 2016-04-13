require 'spec_helper'
describe 'keymaster::x509::key::deploy', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org'
      }
    end
    describe 'with default keymaster and preseeded key' do
      let :pre_condition do
        "include keymaster"
      end
      describe 'with no parameters' do
        let :title do
          'test.example.org'
        end
        it { should contain_file('x509_test.example.org_private_key').with(
          'ensure'  => 'file',
          'path'    => '/etc/ssl/private/test.example.org.pem',
          'owner'   => nil,
          'group'   => nil,
          'content' => %r{^-----BEGIN RSA PRIVATE KEY-----THISISAFAKERSAHASH-----END RSA PRIVATE KEY-----$}
        ) }
      end
      describe 'when absent' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :ensure => 'absent'
          }
        end
        it { should contain_file('x509_test.example.org_private_key').with(
          'ensure'  => 'absent'
        ) }
      end
      describe 'with using parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :path  => '/some/other/key.foo',
            :owner => 'nobody',
            :group => 'nobody'
          }
        end
        it { should contain_file('x509_test.example.org_private_key').with(
          'path'    => '/some/other/key.foo',
          'owner'   => 'nobody',
          'group'   => 'nobody'
        ) }
      end
      describe 'when deploying a certificate that does not exist' do
        let :title do
          'nowhere.com'
        end
        it { should_not contain_file('x509_nowhere.com_certificate') }
        it { should contain_notify('x509_nowhere.com_key_did_not_run').with_message("Can't read key /var/lib/keymaster/x509/nowhere.com/key.pem")}
      end
    end
  end
end
