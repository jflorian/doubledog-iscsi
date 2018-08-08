require 'hiera'
require 'spec_helper'

describe 'iscsi::target::package' do

  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) {
        facts
      }

      packages = hiera::lookup('iscsi::target::package::names',nil,nil)

      packages.each do |package|
        it do
          is_expected.to contain_package(package)
        end
      end

      it do
        is_expected.to contain_file('/etc/tgt/targets.conf')
            .with({
              :owner     => 'root',
              :group     => 'root',
              :mode      => '0640',
              :seluser   => 'system_u',
              :selrole   => 'object_r',
              :seltype   => 'etc_t',
              :show_diff => false,
            })
            .that_comes_before('Class[iscsi::target::service]')
            .that_notifies('Class[iscsi::target::service]')
      end
    end
  end

end
