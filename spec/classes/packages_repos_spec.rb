require 'spec_helper'

describe 'packages_repos', :type => 'class' do
    
  context "Should include apt, add source to apt" do
    let(:facts){{:osfamily => 'Debian', :lsbdistid => 'Debian', :lsbdistcodename=>'Squeeze' }}
    let(:params){{'repos' => {
        'Debian' => {
          'adaptavist_repo' => {
            'key' => "899A9999A5F538E6808F756DC8B73650E8C84716",
            'location' => 'http://apt.example.com/repo',
            'repos' => "/"
          }
        }
      }
    }}
    it do
      should contain_class('apt')
      should contain_apt__source('adaptavist_repo').with(
        'location'          => 'http://apt.example.com/repo',
        'repos'             => '/',
        'key'               => '899A9999A5F538E6808F756DC8B73650E8C84716',
      )
    end
  end

  context "Should include yum, add repo" do
    let(:facts){{:osfamily => 'RedHat' }}
    let(:params){{'repos' => {
        'RedHat' => {
          'adaptavist_repo' => {
            'baseurl' => "http://example_yum.example.com",
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
        'baseurl' => "http://example_yum.example.com",
        'descr' => "IUS Community repository",
        'enabled' => '1',
        'gpgcheck' => '0',
      )
    end
  end

  context "Should not include yum, on unsupported os" do
    let(:facts){{:osfamily => 'Windows' }}
    let(:params){{'repos' => {
        'RedHat' => {
          'adaptavist_repo' => {
            'baseurl' => "http://example_yum.example.com",
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
        'baseurl' => "http://example_yum.example.com",
        'descr' => "IUS Community repository",
        'enabled' => '1',
        'gpgcheck' => '0',
      )
    end
  end

end
