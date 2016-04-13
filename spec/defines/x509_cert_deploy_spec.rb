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
        "include keymaster\nKeymaster::X509::Cert::Pem <| |>\nKeymaster::X509::Cert::P12 <| |>"
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
          'content' => %r{^-----BEGIN CERTIFICATE-----THISISAFAKEHASH-----END CERTIFICATE-----$}
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
          'ensure'  => 'absent'
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
            :group => 'nobody'
          }
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'path'    => '/some/other/certificate.foo',
          'owner'   => 'nobody',
          'group'   => 'nobody'
        ) }
      end
      describe 'when deploying a certificate that does not exist' do
        let :title do
          'nowhere.com'
        end
        it { should_not contain_file('x509_nowhere.com_certificate') }
        it { should contain_notify('x509_nowhere.com_cert_did_not_run').with_message("Can't read certificate /var/lib/keymaster/x509/nowhere.com/certificate.crt")}
      end
      describe 'when deploying a DER cer certificate' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'cer'
          }
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'path'    => '/etc/ssl/cert/test.example.org.cer',
          'content' => %r{^-----BEGIN CERTIFICATE-----THISISAFAKEHASH-----END CERTIFICATE-----$}
        ) }
      end
      describe 'when deploying a DER der certificate' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'der'
          }
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'path'    => '/etc/ssl/cert/test.example.org.der',
          'content' => %r{^-----BEGIN CERTIFICATE-----THISISAFAKEHASH-----END CERTIFICATE-----$}
        ) }
      end
      describe 'when deploying a pkcs12 p12 certificate' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'p12'
          }
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'path'    => '/etc/ssl/cert/test.example.org.p12',
          'content' => %r{^-----BEGIN CERTIFICATE-----THISISAFAKEP12-----END CERTIFICATE-----$}
        ) }
        it { should contain_keymaster__x509__cert__p12('test.example.org').with_type('p12') }
      end
      describe 'when deploying a pkcs12 pfx certificate' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'pfx'
          }
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'path'    => '/etc/ssl/cert/test.example.org.pfx',
          'content' => %r{^-----BEGIN CERTIFICATE-----THISISAFAKEPFX-----END CERTIFICATE-----$}
        ) }
        it { should contain_keymaster__x509__cert__p12('test.example.org').with_type('pfx') }
      end
      describe 'when deploying a pkcs12 p12 certificate' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'pem'
          }
        end
        it { should contain_file('x509_test.example.org_certificate').with(
          'path'    => '/etc/ssl/cert/test.example.org.pem',
          'content' => %r{^-----BEGIN CERTIFICATE-----THISISAFAKEPEM-----END CERTIFICATE-----$}
        ) }
        it { should contain_keymaster__x509__cert__pem('test.example.org') }
      end
      # describe 'when setting an unimplemeted type' do
      #   let :title do
      #     'test.example.org'
      #   end
      #   let :params do
      #     {
      #       :type => 'p12'
      #     }
      #   end
      #   it { should raise_error(Puppet::Error, %r{The certificate type p12 is not yet supported.}) }
      # end
      describe 'when setting an invalid type' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :type => 'foo'
          }
        end
        it { should raise_error(Puppet::Error, %r{validate_re\(\): "foo" does not match \["pem", "cer", "crt", "der", "p12", "pfx"\]}) }
      end
    end
  end
end
