class packages_repos::params {

  case $::osfamily {
      RedHat: {
          $repos = {
            'RedHat' => {
              'rpmforge' => {
                'descr'    => "RHEL ${::releasever} - RPMforge.net - dag",
                'baseurl'  => 'http://www.mirrorservice.org/sites/apt.sw.be/redhat/el6/en/$architecture/rpmforge',
                'enabled'  => 1,
                'priority' => 30,
              },

              'rpmforge-extras' => {
                  'descr'    => "RHEL ${::releasever} - RPMforge.net - extras",
                  'baseurl'  => 'http://www.mirrorservice.org/sites/apt.sw.be/redhat/el6/en/$architecture/extras',
                  'enabled'  => 1,
                  'priority' => 35,
              },

              'rpmforge-testing' => {
                  'descr'    => "RHEL ${::releasever} - RPMforge.net - testing",
                  'baseurl'  => 'http://www.mirrorservice.org/sites/apt.sw.be/redhat/el6/en/$architecture/testing',
                  'enabled'  => 1,
                  'priority' => 40,
              },
            }
          }
      }
      Debian: {
        $repos = { 'Debian' => {} }
      }
      default: {
        $repos = { "${::osfamily}" => {} }
      }
  }
}
