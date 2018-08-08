require 'hiera'
require 'spec_helper'

describe 'iscsi::target::service' do

  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) {
        facts
      }

      it do
        is_expected.to contain_class('iscsi::target::package')
      end

      services = hiera::lookup('iscsi::target::service::names',nil,nil)

      services.each do |service|
        it do
          is_expected.to contain_service(service)
        end
      end

      it do
        is_expected.to contain_firewall('500 accept iSCSI target packets')
            .with({
              :dport  => '3260',
              :proto  => 'tcp',
              :state  => 'NEW',
              :action => 'accept',
            })
      end
    end
  end

end
