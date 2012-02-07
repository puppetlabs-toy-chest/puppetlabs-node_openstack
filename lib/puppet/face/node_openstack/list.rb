require 'puppet/cloudpack'
require 'puppet/face/node_openstack'

Puppet::Face.define :node_openstack, '0.0.1' do

  action :list do

    summary 'List machine instances.'
    description <<-EOT
      Obtains a list of instances from the specified endpoint and
      displays them on the console. Only the instances being managed
      by that endpoint are listed.
    EOT

    Puppet::CloudPack.add_platform_option(self)

    when_invoked do |options|
      Puppet::CloudPack.list(options)
    end

    when_rendering :console do |value|
      value.collect do |id,status_hash|
        "#{id}:\n" + status_hash.collect do |field, val|
          "  #{field}: #{val}"
        end.sort.join("\n")
      end.sort.join("\n")
    end

  end
end
