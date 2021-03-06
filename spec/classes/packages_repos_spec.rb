require 'spec_helper'

describe 'packages_repos', :type => 'class' do
    
  context "Should include apt, add source to apt" do
    let(:facts){{
      :osfamily => 'Debian',
      :lsbdistcodename => 'Squeeze',
      :lsbdistid => 1,
      :puppetversion => Puppet.version
    }}

    let(:params){{'repos' => {
        'Debian' => {
          'adaptavist_repo' => {
            'key' => "30C18A2B",
            'location' => 'http://apt.adaptavist.com/repo',
            'repos' => "/"
          }
        }
      }
    }}
    it do
      should contain_class('apt')
      should contain_apt__source('adaptavist_repo').with(
        'location'          => 'http://apt.adaptavist.com/repo',
        'repos'             => '/',
        'key'               => '30C18A2B',
      )
    end
  end

  context "Should include yum, add repo" do
    let(:facts){{
      :osfamily => 'RedHat',
      :lsbdistid => 1,
      :operatingsystem => 'RedHat',
      :operatingsystemrelease => '7.1'
    }}
    let(:params){{'repos' => {
        'RedHat' => {
          'adaptavist_repo' => {
            'baseurl' => "http://example_yum.adaptavist.com",
            'descr' => "IUS Community repository",
            'enabled' => 1,
            'gpgcheck' => 0,
          }
        }
      }
    }}
    it do
      should contain_class('yum')
      should contain_yumrepo('adaptavist_repo').with(
        'baseurl' => "http://example_yum.adaptavist.com",
        'descr' => "IUS Community repository",
        'enabled' => '1',
        'gpgcheck' => '0',
      )
    end
  end

  context "Should not include yum, on unsupported os" do
    let(:facts){{
      :osfamily => 'Windows',
      :lsbdistid => 1
    }}
    let(:params){{'repos' => {
        'RedHat' => {
          'adaptavist_repo' => {
            'baseurl' => "http://example_yum.adaptavist.com",
            'descr' => "IUS Community repository",
            'enabled' => 1,
            'gpgcheck' => 0,
          }
        }
      }
    }}
    it do
      should_not contain_class('yum')
      should_not contain_yumrepo('adaptavist_repo').with(
        'baseurl' => "http://example_yum.adaptavist.com",
        'descr' => "IUS Community repository",
        'enabled' => '1',
        'gpgcheck' => '0',
      )
    end
  end

end
