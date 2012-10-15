# Public: Install Caffeine.app to /Applications.
#
# activate_on_launch - A Boolean value describing whether Caffeine should be
#                      enabled automatically when the program starts (default:
#                      true).
# launch_on_login    - A Boolean value describing whether Caffeine should be
#                      automatically run when the user logs in (default:
#                      true).
#
# Examples
#
#   # Install Caffeine with all the default options.
#   include caffeine
#
#   # Install Caffeine but don't automatically start on login
#   class { 'caffeine':
#     launch_on_login => false,
#   }
class caffeine(
    $activate_on_launch = true,
    $launch_on_login    = true,
  ) {

  case $activate_on_launch {
    true,false: {}
    default: {
      fail('Class[caffeine]: Invalid activate_on_launch value')
    }
  }

  case $launch_on_login {
    true: { $login_item_ensure = 'present' }
    false: { $login_item_ensure = 'absent' }
    default: {
      fail('Class[caffeine]: Invalid launch_on_login value')
    }
  }

  package { 'Caffeine':
    provider => 'compressed_app',
    source   => 'http://lightheadsw.com/files/releases/com.lightheadsw.Caffeine/Caffeine1.1.1.zip'
  }

  $plist = "/Users/${::luser}/Library/Preferences/com.lightheadsw.Caffeine.plist"
  property_list_key {
    'caffeine: disable startup message':
      ensure     => present,
      path       => $plist,
      key        => 'SuppressLaunchMessage',
      value      => true,
      value_type => 'boolean';
    'caffeine: activate on launch':
      ensure     => present,
      path       => $plist,
      key        => 'ActivateOnLaunch',
      value      => $activate_on_launch,
      value_type => 'boolean';
  }

  osx_login_item { 'Caffeine':
    ensure  => $login_item_ensure,
    path    => '/Applications/Caffeine.app',
    require => [
      Package['Caffeine'],
      Property_list_key['caffeine: disable startup message'],
      Property_list_key['caffeine: activate on launch'],
    ],
  }

  exec { 'launch caffeine':
    command     => '/usr/bin/open /Applications/Caffeine.app',
    refreshonly => true,
    subscribe   => Package['Caffeine'],
    require     => Osx_login_item['Caffeine'],
  }
}
