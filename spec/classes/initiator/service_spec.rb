require 'hiera'
require 'spec_helper'

describe 'iscsi::initiator::service' do

  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')

  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) {
        facts
      }

      it do
        is_expected.to contain_class('iscsi::initiator::package')
      end

      services = hiera::lookup('iscsi::initiator::service::names',nil,nil)

      services.each do |service|
        it do
          is_expected.to contain_service(service)
        end
      end

      context "Initiator name set" do
        let(:params) {{
            :initiator_name => 'iqn.2018-08.com.example:725b60308b6',
        }}

        it do
          is_expected.to contain_file('/etc/iscsi/initiatorname.iscsi')
            .with({
              :content => "InitiatorName=iqn.2018-08.com.example:725b60308b6\n",
            })
            .that_notifies('Service[iscsid]')
            .that_requires('Class[iscsi::initiator::package]')
        end
      end

      context "Initiator name not set" do
        let(:params) {{
            :initiator_name => :undef,
        }}

        it do
          is_expected.not_to contain_file('/etc/iscsi/initiatorname.iscsi')
        end
      end

    end
  end

end
