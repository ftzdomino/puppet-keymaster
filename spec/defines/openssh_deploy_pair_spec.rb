require 'spec_helper'
describe 'keymaster::openssh::deploy_pair', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    describe 'with default keymaster' do
      let :pre_condition do
        "include keymaster\nkeymaster::openssh::key{'tester@test.example.org': }\nuser{'tester': home => '/home/tester', gid => 'tester'}\n"
      end
      # rspec-puppet does not yet test instanced virtual resources
      # describe 'with only a user' do
      #   let :title do
      #     'tester@test.example.org'
      #   end
      #   let :params do
      #     {
      #       :user => 'tester'
      #     }
      #   end
      #   it { should contain_keymaster__openssh__key__deploy('tester@test.example.org').with(
      #     :user     => 'tester',
      #     :filename => 'id_rsa',
      #     :ensure   => 'present'
      #   ) }
      # end
      # describe 'when overriding the filename' do
      #   let :title do
      #     'tester@test.example.org'
      #   end
      #   let :params do
      #     {
      #       :user     => 'tester',
      #       :filename => 'magic_key'
      #     }
      #   end
      #   it { should contain_keymaster__openssh__key__deploy('tester@test.example.org').with(
      #     :user     => 'tester',
      #     :filename => 'magic_key',
      #     :ensure   => 'present'
      #   ) }
      # end
      # describe 'when overriding the ensure' do
      #   let :title do
      #     'tester@test.example.org'
      #   end
      #   let :params do
      #     {
      #       :user   => 'tester',
      #       :ensure => 'absent'
      #     }
      #   end
      #   it { should contain_keymaster__openssh__key__deploy('tester@test.example.org').with(
      #     :user     => 'tester',
      #     :filename => 'id_rsa',
      #     :ensure   => 'absent'
      #   ) }
      # end
      # describe 'when overriding the filename and ensure' do
      #   let :title do
      #     'tester@test.example.org'
      #   end
      #   let :params do
      #     {
      #       :user     => 'tester',
      #       :filename => 'magic_key',
      #       :ensure   => 'absent'
      #     }
      #   end
      #   it { should contain_keymaster__openssh__key__deploy('tester@test.example.org').with(
      #     :user     => 'tester',
      #     :filename => 'magic_key',
      #     :ensure   => 'absent'
      #   ) }
      # end
      describe 'without a defined key' do
        let :title do
          'no@key.defined'
        end
        let :params do
          {
            :user => 'tester'
          }
        end
        it { should raise_error(Puppet::Error, /There is no Keymaster::Openssh::Key defined that matches 'no@key.defined'/) }
      end
      describe 'with an undefined user' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :user => 'nobody'
          }
        end
        it { should raise_error(Puppet::Error, /The user 'nobody' has not been defined in Puppet/) }
      end
      describe 'with no parameters' do
        let :title do
          'tester@test.example.org'
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Deploy_pair/) }
      end
      describe 'with only a filename' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :filename => 'test_id_rsa'
          }
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Deploy_pair/) }
      end
      describe 'with only an ensure' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :ensure => 'present'
          }
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Deploy_pair/) }
      end
      describe 'with ensure and filename, but no user' do
        let :title do
          'tester@test.example.org'
        end
        let :params do
          {
            :ensure => 'present',
            :filename => 'test_id_rsa'
          }
        end
        it { should raise_error(Puppet::Error, /Must pass user to Keymaster::Openssh::Deploy_pair/) }
      end
    end
  end
end