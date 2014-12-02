require 'spec_helper'
describe 'keymaster::openssh::key', :type => :define do
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
        "include keymaster\nKeymaster::Openssh::Key::Generate <| |>\nKeymaster::Openssh::Key::Deploy <| |> { user => 'tester' }\nKeymaster::Openssh::Key::Authorized_key <| |> { user => 'tester' }"
      end
      describe 'with no parameters' do
        let :title do
          'tester@test.example.org'
        end
        it { should contain_keymaster__openssh__key__generate('tester@test.example.org').with(
          'ensure'  => 'present',
          'force'   => false,
          'keytype' => 'rsa',
          'length'  => '2048',
          'tag'     => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__generate('tester@test.example.org').without(
          'maxdays') }
        it { should contain_keymaster__openssh__key__generate('tester@test.example.org').without(
          'mindate') }
        it { should contain_keymaster__openssh__key__deploy('tester@test.example.org').with(
          'ensure'   => 'present',
          'filename' => 'id_rsa',
          'tag'      => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__authorized_key('tester@test.example.org').with(
          'ensure'   => 'present',
          'tag'      => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__authorized_key('tester@test.example.org').without( 'options' ) }
      end
      describe 'when specifying a DSA key' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :keytype => 'dsa',
            :length  => '4096'
          }
        end
        it { should contain_keymaster__openssh__key__generate('tester@test.example.org').with(
          'ensure'  => 'present',
          'force'   => false,
          'keytype' => 'dsa',
          'length'  => '1024',
          'tag'     => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__generate('tester@test.example.org').without(
          'maxdays') }
        it { should contain_keymaster__openssh__key__generate('tester@test.example.org').without(
          'mindate') }
        it { should contain_keymaster__openssh__key__deploy('tester@test.example.org').with(
          'ensure'   => 'present',
          'filename' => 'id_dsa',
          'tag'      => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__authorized_key('tester@test.example.org').with(
          'ensure'   => 'present',
          'tag'      => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__authorized_key('tester@test.example.org').without( 'options' ) }
      end
      describe 'when customising the key parameters' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :filename => 'this_key',
            :length   => '3072',
            :maxdays  => '34',
            :mindate  => '12/12/2014',
            :force    => true,
            :options  => '--these --are --options'
          }
        end
        it { should contain_keymaster__openssh__key__generate('tester@test.example.org').with(
          'ensure'  => 'present',
          'force'   => true,
          'keytype' => 'rsa',
          'length'  => '3072',
          'maxdays' => '34',
          'mindate' => '12/12/2014',
          'tag'     => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__deploy('tester@test.example.org').with(
          'ensure'   => 'present',
          'filename' => 'this_key',
          'tag'      => 'user_at_test.example.org'
        ) }
        it { should contain_keymaster__openssh__key__authorized_key('tester@test.example.org').with(
          'ensure'   => 'present',
          'options'  => '--these --are --options',
          'tag'      => 'user_at_test.example.org'
        ) }
      end
    end
  end
end
