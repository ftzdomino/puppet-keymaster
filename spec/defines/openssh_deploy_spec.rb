require 'spec_helper'
describe 'keymaster::openssh::key::deploy', :type => :define do
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
        "include keymaster\nuser{'tester': home => '/home/tester}"
      end
      describe 'with minumum parameters' do
        # These will most likely fail without fixtures set up
        let :title do
          'user@test.example.org'
        end
        let :params do
          {
            :user     => 'tester',
            :filename => 'id_rsa'
          }
        end
        it { should contain_file('/home/tester/.ssh').with(
          'ensure' => 'directory',
          'owner'  => 'tester',
          'group'  => 'tester',
          'mode'   => '0700'
        ) }
        # Testing the content should also be done, requires fixtures set up
        it { should contain_file('/home/tester/.ssh/id_rsa').with(
          'ensure'  => 'file',
          'owner'   => 'tester',
          'group'   => 'tester',
          'mode'    => '0600',
          'require' => 'File[/home/tester/.ssh]'
        ) }
        # Testing the content should also be done, requires fixtures set up
        it { should contain_file('/home/tester/.ssh/id_rsa.pub').with(
          'ensure'  => 'file',
          'owner'   => 'tester',
          'group'   => 'tester',
          'mode'    => '0644',
          'require' => 'File[/home/tester/.ssh]'
        ) }
      end
      describe 'when ensure is absent' do
        # These will most likely fail without fixtures set up
        let :title do
          'user@test.example.org'
        end
        let :params do
          {
            :ensure   => 'absent',
            :user     => 'tester',
            :filename => 'id_rsa'
          }
        end
        it { should contain_file('/home/tester/.ssh').with(
          'ensure' => 'directory',
          'owner'  => 'tester',
          'group'  => 'tester',
          'mode'   => '0700'
        ) }
        # Testing the content should also be done, requires fixtures set up
        it { should contain_file('/home/tester/.ssh/id_rsa').with_ensure('absent') }
        # Testing the content should also be done, requires fixtures set up
        it { should contain_file('/home/tester/.ssh/id_rsa.pub').with_ensure('absent') }
      end
      describe 'when key source files not present' do
        let :title do
          'user@test.example.org'
        end
        let :params do
          {
            :user     => 'tester',
            :filename => 'id_rsa'
          }
        end
        it { should_not contain_file('/home/tester/.ssh') }
        it { should_not contain_file('/home/tester/.ssh/id_rsa') }
        it { should_not contain_file('/home/tester/.ssh/id_rsa.pub') }
      end
    end
  end
end
