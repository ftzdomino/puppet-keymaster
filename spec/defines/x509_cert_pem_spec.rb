require 'spec_helper'
describe 'keymaster::x509::cert::pem', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org'
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
        it { should contain_file('x509_test.example.org_pem').with(
          'ensure' => 'file',
          'path'   => '/var/lib/keymaster/x509/test.example.org/certificate.pem',
          'owner'  => 'puppet',
          'group'  => 'puppet',
          'mode'   => '0640'
        ) }
        it { should contain_exec('convert_test.example.org_to_pem').with(
          'command' => 'openssl x509 -in /var/lib/keymaster/x509/test.example.org/certificate.crt -out /var/lib/keymaster/x509/test.example.org/certificate.pem',
          'creates' => '/var/lib/keymaster/x509/test.example.org/certificate.pem',
          'user'    => 'puppet',
          'before'  => 'File[x509_test.example.org_pem]',
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
        it { should contain_file('x509_test.example.org_pem').with(
          'ensure' => 'absent',
          'path'   => '/var/lib/keymaster/x509/test.example.org/certificate.pem'
        ) }
        it { should_not contain_exec('convert_test.example.org_to_pem')}
      end
    end
  end
end
