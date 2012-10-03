# Public: Install Caffeine.app to /Applications.
#
# Examples
#
#   include caffeine
class caffeine {
  package { 'Caffeine':
    provider => 'compressed_app',
    source   => 'http://lightheadsw.com/files/releases/com.lightheadsw.Caffeine/Caffeine1.1.1.zip'
  }
}
