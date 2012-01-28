require 'puppet/face/node_openstack'
require 'puppet/cloudpack'

Puppet::Face.define :node_openstack, '0.0.1' do

  action :list_flavors do

    summary 'List available OpenStack key names.'

    description <<-'EOT'
      This action lists the available OpenStack key names and their fingerprints.
      These keynames are specific to the specified endpoint.
      Any key name from this list is a valid argument for the create action's
      --keyname option.
    EOT

    Puppet::CloudPack.add_platform_option(self)
    Puppet::CloudPack.add_region_option(self)

    when_invoked do |options|
      options = Puppet::CloudPack.merge_default_options(options)
      Puppet::CloudPack.create_connection(options).flavors.all(true)
    end

    when_rendering :console do |value|
      value.collect do |key_hash|
        "#{key_hash['name']} (#{key_hash['fingerprint']})"
      end.sort.join("\n")
    end

  end
end
