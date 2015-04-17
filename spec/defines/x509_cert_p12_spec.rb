require 'spec_helper'
describe 'keymaster::x509::cert::p12', :type => :define do
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
        "include keymaster\n"
      end
      describe 'with no parameters' do
        let :title do
          'test.example.org'
        end
        it { should contain_file('x509_test.example.org_p12').with(
          'ensure' => 'file',
          'path'   => '/var/lib/keymaster/x509/test.example.org/certificate.p12',
          'owner'  => 'puppet',
          'group'  => 'puppet',
          'mode'   => '0640',
        ) }
        it { should contain_exec('convert_test.example.org_to_p12').with(
          'command' => 'openssl pkcs12 -export -out /var/lib/keymaster/x509/test.example.org/certificate.p12 -in /var/lib/keymaster/x509/test.example.org/certificate.crt -inkey /var/lib/keymaster/x509/test.example.org/key.pem',
          'creates' => '/var/lib/keymaster/x509/test.example.org/certificate.p12',
          'user'    => 'puppet',
          'before'  => 'File[x509_test.example.org_p12]',
          'path'    => '/usr/bin:/usr/sbin:/bin:/sbin'
        ) }
      end
      describe 'when specifying the pfx type' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'pfx',
          }
        end
        it { should contain_file('x509_test.example.org_p12').with(
          'ensure' => 'file',
          'path'   => '/var/lib/keymaster/x509/test.example.org/certificate.pfx',
          'owner'  => 'puppet',
          'group'  => 'puppet',
          'mode'   => '0640',
        ) }
        it { should contain_exec('convert_test.example.org_to_p12').with(
          'command' => 'openssl pkcs12 -export -out /var/lib/keymaster/x509/test.example.org/certificate.pfx -in /var/lib/keymaster/x509/test.example.org/certificate.crt -inkey /var/lib/keymaster/x509/test.example.org/key.pem',
          'creates' => '/var/lib/keymaster/x509/test.example.org/certificate.pfx',
          'user'    => 'puppet',
          'before'  => 'File[x509_test.example.org_p12]',
          'path'    => '/usr/bin:/usr/sbin:/bin:/sbin'
        ) }
      end
      describe 'when absent' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :ensure       => 'absent',
          }
        end
        it { should contain_file('x509_test.example.org_p12').with(
          'ensure' => 'absent',
          'path'   => '/var/lib/keymaster/x509/test.example.org/certificate.p12'
        ) }
        it { should_not contain_exec('convert_test.example.org_to_p12')}
      end
    end
  end
end
