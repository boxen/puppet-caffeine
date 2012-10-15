require 'spec_helper'

describe 'caffeine' do
  let(:facts) { {:luser => 'testuser'} }

  context "with default values" do
    it do
      should contain_package('Caffeine').with({
        :provider => 'compressed_app',
        :source   => 'http://lightheadsw.com/files/releases/com.lightheadsw.Caffeine/Caffeine1.1.1.zip',
      })
    end

    it do
      should contain_property_list_key('caffeine: disable startup message').with({
        :ensure     => 'present',
        :path       => "/Users/#{facts[:luser]}/Library/Preferences/com.lightheadsw.Caffeine.plist",
        :key        => 'SuppressLaunchMessage',
        :value      => true,
        :value_type => 'boolean',
      })
    end

    it do
      should contain_property_list_key('caffeine: activate on launch').with({
        :ensure     => 'present',
        :path       => "/Users/#{facts[:luser]}/Library/Preferences/com.lightheadsw.Caffeine.plist",
        :key        => 'ActivateOnLaunch',
        :value      => true,
        :value_type => 'boolean',
      })
    end

    it do
      should contain_osx_login_item('Caffeine').with({
        :ensure  => 'present',
        :path    => '/Applications/Caffeine.app',
        :require => [
          'Package[Caffeine]',
          'Property_list_key[caffeine: disable startup message]',
          'Property_list_key[caffeine: activate on launch]',
        ],
      })
    end

    it do
      should contain_exec('launch caffeine').with({
        :command     => '/usr/bin/open /Applications/Caffeine.app',
        :refreshonly => true,
        :subscribe   => 'Package[Caffeine]',
        :require     => 'Osx_login_item[Caffeine]',
      })
    end
  end

  context "with activate_on_launch => false" do
    let(:params) { {:activate_on_launch => false} }

    it do
      should contain_property_list_key('caffeine: activate on launch').with({
        :ensure     => 'present',
        :path       => "/Users/#{facts[:luser]}/Library/Preferences/com.lightheadsw.Caffeine.plist",
        :key        => 'ActivateOnLaunch',
        :value      => false,
        :value_type => 'boolean',
      })
    end
  end

  context "with launch_on_launch => false" do
    let(:params) { {:launch_on_login => false} }

    it do
      should contain_osx_login_item('Caffeine').with({
        :ensure  => 'absent',
        :path    => '/Applications/Caffeine.app',
        :require => [
          'Package[Caffeine]',
          'Property_list_key[caffeine: disable startup message]',
          'Property_list_key[caffeine: activate on launch]',
        ],
      })
    end
  end
end
