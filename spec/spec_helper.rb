require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'
require 'rspec-puppet-facts'
include RspecPuppetFacts

# Uncomment this to show coverage report, also useful for debugging
#at_exit { RSpec::Puppet::Coverage.report! }

#set to "yes" to enable the future parser, the equivalent of setting parser=future in puppet.conf.
ENV['FUTURE_PARSER'] = 'yes'

# set to "yes" to enable strict variable checking, the equivalent of setting strict_variables=true in puppet.conf.
ENV['STRICT_VARIABLES'] = 'no'

# set to the desired ordering method ("title-hash", "manifest", or "random") to set the order of unrelated resources
# when applying a catalog. Leave unset for the default behavior, currently "random". This is equivalent to setting
# ordering in puppet.conf.
ENV['ORDERING'] = 'manifest'

# set to "no" to enable structured facts, otherwise leave unset to retain the current default behavior.
# This is equivalent to setting stringify_facts=false in puppet.conf.
ENV['STRINGIFY_FACTS']  = 'no'

# set to "yes" to enable the $facts hash and trusted node data, which enabled $facts and $trusted hashes.
# This is equivalent to setting trusted_node_data=true in puppet.conf.
ENV['TRUSTED_NODE_DATA'] = 'yes'

RSpec.configure do |c|
    c.formatter = 'documentation'
    c.mock_with :rspec
    c.hiera_config = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'hiera', 'hiera.yaml')
    c.manifest_dir = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'manifests')
    c.manifest = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'manifests', 'site.pp')
    c.after(:suite) do
        RSpec::Puppet::Coverage.report!(95)
    end
end
