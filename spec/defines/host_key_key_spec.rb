require 'spec_helper'
describe 'keymaster::host_key::key', :type => :define do
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
        "include keymaster\nuser{'tester': home => '/home/tester', gid => 'tester'}\nKeymaster::Host_key::Key::Generate <| |>\nKeymaster::Host_key::Key::Deploy <| |>"
      end
      describe 'with no parameters' do
        let :title do
          'test.example.org'
        end
        it { should contain_keymaster__host_key__key__generate('test.example.org').with(
          'ensure'  => 'present',
          'force'   => false,
          'keytype' => 'rsa',
          'length'  => '2048',
          'tag'     => 'test.example.org'
        ) }
        it { should contain_keymaster__host_key__key__generate('test.example.org').without(
          'maxdays') }
        it { should contain_keymaster__host_key__key__generate('test.example.org').without(
          'mindate') }
        it { should contain_keymaster__host_key__key__deploy('test.example.org').with(
          'ensure'   => 'present',
          'tag'      => 'test.example.org'
        ) }
        it { should_not contain_keymaster__host_key__redeploy('test.example.org') }
      end
      describe 'when also deploying the host key' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :deploy => true
          }
        end
        it { should contain_keymaster__host_key__redeploy('test.example.org').with(
          'ensure' => 'present'
        ) }
      end
      describe 'when specifying a DSA key' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :keytype => 'dsa',
            :length  => '4096'
          }
        end
        it { should contain_keymaster__host_key__key__generate('test.example.org').with(
          'ensure'  => 'present',
          'force'   => false,
          'keytype' => 'dsa',
          'length'  => '1024',
          'tag'     => 'test.example.org'
        ) }
        it { should contain_keymaster__host_key__key__generate('test.example.org').without(
          'maxdays') }
        it { should contain_keymaster__host_key__key__generate('test.example.org').without(
          'mindate') }
        it { should contain_keymaster__host_key__key__deploy('test.example.org').with(
          'ensure'   => 'present',
          'tag'      => 'test.example.org'
        ) }
      end
      describe 'when customising the key parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            :length   => '3072',
            :maxdays  => '34',
            :mindate  => '12/12/2014',
            :force    => true,
          }
        end
        it { should contain_keymaster__host_key__key__generate('test.example.org').with(
          'ensure'  => 'present',
          'force'   => true,
          'keytype' => 'rsa',
          'length'  => '3072',
          'maxdays' => '34',
          'mindate' => '12/12/2014',
          'tag'     => 'test.example.org'
        ) }
        it { should contain_keymaster__host_key__key__deploy('test.example.org').with(
          'ensure'   => 'present',
          'tag'      => 'test.example.org'
        ) }
      end
    end
  end
end
