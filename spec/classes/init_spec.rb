require 'spec_helper'
describe 'keymaster', :type => :class do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    describe 'with no parameters' do
      it { should contain_class('keymaster::params') }
      it { should contain_file('key_store_base').with(
        'ensure'  => 'directory',
        'path'    => '/var/lib/keymaster',
        'owner'   => 'puppet',
        'group'   => 'puppet',
        'recurse' => true,
        'mode'    => '0640'
      ) }
      it { should contain_file('key_store_openssh').with(
        'ensure'  => 'directory',
        'path'    => '/var/lib/keymaster/openssh',
        'owner'   => 'puppet',
        'group'   => 'puppet',
        'recurse' => true,
        'mode'    => '0640'
      ) }
    end
  end

  context 'on a RedHat OS' do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    it { should raise_error(Puppet::Error, /The keymaster Puppet module does not support RedHat family of operating systems/) }
  end

  context 'on an Unknown OS' do
    let :facts do
      {
        :osfamily               => 'Unknown',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    it { should raise_error(Puppet::Error, /The keymaster Puppet module does not support Unknown family of operating systems/) }
  end

end
