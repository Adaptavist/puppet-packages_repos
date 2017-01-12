# Registers package repositories based on osfamily.
# Supports RedHat and Debian,
# Makes sure repos are registered before any package is installed.
# Default repos set in params.pp. 
# Ability to add new ones on per host bases and merge with default.
#
# Params are passed as part hash on global level 
# or per host via packages_repos::repos
# packages_repos::merge_repos identifies per host 
# if default packages should be merged with custom ones
#
# Global level for Debian:
#
# packages_repos::repos:
#     'Debian':
#          example_repo:
#            location: 'http://example.adaptavist.com/'
#            repos: '/'
#            key: 'key'
#            include_src: false
#            release: ''
#            key_content: "-----BEGIN PGP PUBLIC KEY BLOCK-----\n"
#          another_example_repo:
#            location: 'http://another_example.adaptavist.com/'
#            repos: '/'
#            key: 'key'
#            include_src: false
#            release: ''
#            key_content: "-----BEGIN PGP PUBLIC KEY BLOCK-----\n"
#     'RedHat':
#          example_repo:
#            baseurl => "http://example_yum.adaptavist.com",
#            descr => "IUS Community repository",
#            enabled => 1,
#            gpgcheck => 0
#
#
# Host specific setup
#
# hosts:
#   host1:
#     packages_repos::merge_repos: 'false'
#     packages_repos::repos:
#       'RedHat':
#         example_repo:
#           baseurl => "http://example_yum.adaptavist.com",
#           descr => "IUS Community repository",
#           enabled => 1,
#           gpgcheck => 0
#       'Debian':
#         example_repo:
#           location => "http://example_yum.adaptavist.com",
#           repos => '/',
#           key: 'key'
#           include_src: false
#           release: ''

class packages_repos(
        $repos       = $packages_repos::params::repos,
        $merge_repos = true,
    ) inherits packages_repos::params {

    # get os specific repos
    if $repos[$::osfamily] {
        $os_repos=$repos[$::osfamily]
        validate_hash($os_repos)
    } else {
        $os_repos={}
    }

    $host_hash = hiera('host', undef)
    if ($host_hash != undef) {
        #if so validate the hash
        validate_hash($host_hash)
        #if a host level "merge_repos" flag has been set use it, 
        # otherwise use the global flag
        $real_merge_repos = $host_hash['packages_repos::merge_repos']? {
            default => $host_hash['packages_repos::merge_repos'],
            undef => $merge_repos,
        }
        #check if there is a host level load list is defined
        if ($host_hash['packages_repos::repos']) {
            validate_hash($host_hash['packages_repos::repos'])
            $custom_repos = $host_hash['packages_repos::repos'][$::osfamily]
            validate_hash($custom_repos)
            #if so and we have merging emabled merge global and host values
            if (any2bool($real_merge_repos)) {
                $real_repos=merge($os_repos, $custom_repos)
            }
            #if merging is disabled use the host values
            else {
                $real_repos=$custom_repos
            }
        } else {
            $real_repos=$os_repos
        }
    } else {
        $real_repos=$os_repos
    }

    #if the load list is set create then
    if ($real_repos) {
        validate_hash($real_repos)
        case $::osfamily {
            'RedHat': {
                if !defined(Class['yum']){
                    class {'yum':}
                }
                Yum::Managed_yumrepo<| |> -> Package<| |>
                create_resources(yum::managed_yumrepo, $real_repos)
            }
            'Debian': {
                if !defined(Class['apt']){
                    class { 'apt':}
                }
                Apt::Source<| |> -> Package<| |>
                create_resources(apt::source, $real_repos)
            }
            default: {}
        }
    }
}
