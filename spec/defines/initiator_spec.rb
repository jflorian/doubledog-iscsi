require 'spec_helper'

describe 'iscsi::initiator' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) do
        facts
      end

      context "CHAP enabled" do
        let(:title) { '192.168.0.1' }

        let(:params) {{
          :password    => 'test',
          :user        => 'username',
          :enable_chap => true,
        }}

        it do
          is_expected.to contain_file('/etc/iscsi/iscsid.conf')
            .with({
                :content => /^node.session.auth.authmethod = CHAP$/,
            })
        end

        it do
            is_expected.to contain_exec("discover iSCSI targets at '192.168.0.1:3260'")
                .with({
                  :path    => '/usr/sbin',
                  :command => "iscsiadm -m discovery -t sendtargets -p 192.168.0.1:3260 -l",
                  :unless  => "iscsiadm -m node -p '192.168.0.1:3260'",
                })
                .that_requires('Class[iscsi::initiator::package]')
                .that_notifies('Class[iscsi::initiator::service]')
        end
      end

      context "CHAP disabled" do
        let(:title) { '192.168.0.1' }

        let(:params) {{
          :password    => nil,
          :user        => nil,
          :enable_chap => false,
        }}

        it do
          is_expected.to contain_file('/etc/iscsi/iscsid.conf')
            .with({
                :content => /^node.session.auth.authmethod = None$/,
            })
        end

        it do
            is_expected.to contain_exec("discover iSCSI targets at '192.168.0.1:3260'")
                .with({
                  :path    => '/usr/sbin',
                  :command => "iscsiadm -m discovery -t sendtargets -p 192.168.0.1:3260 -l",
                  :unless  => "iscsiadm -m node -p '192.168.0.1:3260'",
                })
                .that_requires('Class[iscsi::initiator::package]')
                .that_notifies('Class[iscsi::initiator::service]')
        end
      end

    end
  end
end
