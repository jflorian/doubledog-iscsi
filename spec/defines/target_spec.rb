require 'spec_helper'

describe 'iscsi::target' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) do
        facts
      end

      let(:title) { 'sdb_target' }

      iqn = 'iqn.2018-08.com.example.f5.3.65.55.1.0.0.20'

      let(:params) {{
        :backing   => '/dev/sdb1',
        :password  => 'password',
        :user      => 'username',
        :ipaddress => '192.168.0.5',
        :iqn       => iqn,
      }}

      it do
        is_expected.to contain_file("/etc/tgt/conf.d/#{iqn}.conf")
            .that_notifies('Class[iscsi::target::service]')
            .that_subscribes_to('Class[iscsi::target::package]')
      end

    end
  end
end
