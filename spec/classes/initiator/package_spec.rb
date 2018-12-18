require 'hiera'
require 'spec_helper'

describe 'iscsi::initiator::package' do

  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) {
        facts
      }

      packages = hiera::lookup('iscsi::initiator::package::names',nil,nil)

      packages.each do |package|
        it do
          is_expected.to contain_package(package)
        end
      end
    end
  end

end
