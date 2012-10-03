require 'spec_helper'

describe 'caffeine' do
  it do
    should contain_package('Caffeine').with({
      :provider => 'compressed_app',
      :source   => 'http://lightheadsw.com/files/releases/com.lightheadsw.Caffeine/Caffeine1.1.1.zip',
    })
  end
end
