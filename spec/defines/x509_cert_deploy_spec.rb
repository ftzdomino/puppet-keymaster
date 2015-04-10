require 'spec_helper'
describe 'keymaster::x509::cert::deploy', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    describe 'with default keymaster and preseeded certificate' do
      let :pre_condition do
        "include keymaster"
      end
      describe 'with no parameters' do
        let :title do
          'test.example.org'
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'ensure'  => 'file',
          'path'    => '/etc/ssl/cert/test.example.org.crt',
          'owner'   => nil,
          'group'   => nil,
          'content' => %r{^-----BEGIN CERTIFICATE-----THISISAFAKEHASH-----END CERTIFICATE-----$},
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
        it { should contain_file('x509_test.example.org_certificate').with(
          'ensure'  => 'absent',
        ) }
      end
      describe 'with using parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :path  => '/some/other/certificate.foo',
            :owner => 'nobody',
            :group => 'nobody',
          }
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'path'    => '/some/other/certificate.foo',
          'owner'   => 'nobody',
          'group'   => 'nobody',
        ) }
      end
      describe 'when deploying a certificate that does not exist' do
        let :title do
          'nowhere.com'
        end
        it { should_not contain_file('x509_nowhere.com_certificate') }
        it { should contain_notify('x509_nowhere.com_did_not_run').with_message("Can't read certificate /var/lib/keymaster/x509/nowhere.com/certificate.crt")}
      end
      describe 'when setting an unimplemeted type' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'p12'
          }
        end
        it { should raise_error(Puppet::Error, %r{The certificate type p12 is not yet supported.}) }
      end
      describe 'when setting an invalid type' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'foo'
          }
        end
        it { should raise_error(Puppet::Error, %r{validate_re\(\): "foo" does not match \["pem", "cer", "crt", "der", "p12"\]}) }
      end
    end
  end
end
