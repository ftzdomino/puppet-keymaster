require 'spec_helper'
describe 'keymaster::x509::cert::generate', :type => :define do
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
      describe 'with minimum parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :commonname   => 'test.example.org',
          }
        end
        it { should contain_file('x509_test.example.org_dir').with(
          'ensure' => 'directory',
          'path'   => '/var/lib/keymaster/x509/test.example.org',
          'mode'   => '0755',
          'owner'  => 'puppet',
          'group'  => 'puppet',
        ) }
        it { should contain_file('x509_test.example.org_cnf').with(
          'ensure' => 'file',
          'path'   => '/var/lib/keymaster/x509/test.example.org/config.cnf',
          'mode'   => '0640',
          'owner'  => 'puppet',
          'group'  => 'puppet',
        ) }
        it { should contain_file('x509_test.example.org_key').with(
          'ensure' => 'file',
          'path'   => '/var/lib/keymaster/x509/test.example.org/key.pem',
          'mode'   => '0640',
          'owner'  => 'puppet',
          'group'  => 'puppet',
        ) }
        it { should contain_file('x509_test.example.org_csr').with(
          'ensure' => 'file',
          'path'   => '/var/lib/keymaster/x509/test.example.org/request.csr',
          'mode'   => '0640',
          'owner'  => 'puppet',
          'group'  => 'puppet',
        ) }
        it { should contain_file('x509_test.example.org_crt').with(
          'ensure' => 'file',
          'path'   => '/var/lib/keymaster/x509/test.example.org/certificate.crt',
          'mode'   => '0640',
          'owner'  => 'puppet',
          'group'  => 'puppet',
        ) }
        it { should contain_exec('x509_test.example.org_key').with(
          'path'    => '/usr/bin:/usr/sbin:/bin:/sbin',
          'command' => 'openssl genrsa -out /var/lib/keymaster/x509/test.example.org/key.pem 2048',
          'user'    => 'puppet',
          'group'   => 'puppet',
          'creates' => '/var/lib/keymaster/x509/test.example.org/key.pem',
          'require' => 'File[x509_test.example.org_cnf]',
          'before'  => 'File[x509_test.example.org_key]',
        ) }
        it { should contain_exec('x509_test.example.org_csr').with(
          'path'    => '/usr/bin:/usr/sbin:/bin:/sbin',
          'command' => 'openssl req -new -key /var/lib/keymaster/x509/test.example.org/key.pem -out /var/lib/keymaster/x509/test.example.org/request.csr -config /var/lib/keymaster/x509/test.example.org/config.cnf',
          'user'    => 'puppet',
          'group'   => 'puppet',
          'creates' => '/var/lib/keymaster/x509/test.example.org/request.csr',
          'require' => 'File[x509_test.example.org_key]',
          'before'  => 'File[x509_test.example.org_csr]',
        ) }
        it { should contain_exec('x509_test.example.org_crt').with(
          'path'    => '/usr/bin:/usr/sbin:/bin:/sbin',
          'command' => 'openssl x509 -req -days 365 -in /var/lib/keymaster/x509/test.example.org/request.csr -signkey /var/lib/keymaster/x509/test.example.org/key.pem -out /var/lib/keymaster/x509/test.example.org/certificate.crt',
          'user'    => 'puppet',
          'group'   => 'puppet',
          'creates' => '/var/lib/keymaster/x509/test.example.org/certificate.crt',
          'require' => 'File[x509_test.example.org_csr]',
          'before'  => 'File[x509_test.example.org_crt]',
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^default_keyfile    = /var/lib/keymaster/x509/test.example.org/key.pem$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^commonName             = test.example.org$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^req_extensions     = req_aliases}
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^localityName           = }
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^stateOrProvinceName    = }
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^emailAddress           = }
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^\[ req_aliases \]$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^subjectAltName = "}
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^countryName            =}
        ) }
        it { should contain_file('x509_test.example.org_cnf').without_content(
          %r{^organizationName       =}
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
        it { should contain_file('x509_test.example.org_dir').with(
          'ensure' => 'absent',
        ) }
        it { should contain_file('x509_test.example.org_cnf').with(
          'ensure' => 'absent',
        ) }
        it { should contain_file('x509_test.example.org_key').with(
          'ensure' => 'absent',
        ) }
        it { should contain_file('x509_test.example.org_csr').with(
          'ensure' => 'absent',
        ) }
        it { should contain_file('x509_test.example.org_crt').with(
          'ensure' => 'absent',
        ) }
        it { should_not contain_exec('x509_test.example.org_key') }
        it { should_not contain_exec('x509_test.example.org_csr') }
        it { should_not contain_exec('x509_test.example.org_crt') }
      end
      describe 'customising certificate configuration' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
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
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^default_keyfile    = /var/lib/keymaster/x509/test.example.org/key.pem$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^commonName             = test.example.org$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^countryName            = NZ$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^organizationName       = Test Example Organization$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^req_extensions     = req_aliases$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^localityName           = above$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^stateOrProvinceName    = plasma$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^emailAddress           = test@example.com$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^\[ req_aliases \]$}
        ) }
        it { should contain_file('x509_test.example.org_cnf').with_content(
          %r{^subjectAltName = "DNS: first, DNS: second, DNS: third"$}
        ) }
      end
    end
  end
end
