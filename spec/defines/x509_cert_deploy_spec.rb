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
    describe 'with default keymaster and realising stored resources' do
      let :pre_condition do
        "include keymaster\nKeymaster::X509::Cert::Generate <| |>\nKeymaster::X509::Cert::Deploy <| path => '/tmp/cert.crt' |>"
      end
      describe 'with minimum parameters' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            
          }
        end

      end
      describe 'when absent' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            
          }
        end

      end
      describe 'customising certificate generation and content' do
        let :title do
          'test.example.org'
        end
        let :params do
          {
            
          }
        end

      end
    end
  end
end
