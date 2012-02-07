require 'puppet/cloudpack'
require 'puppet/face/node_openstack'

Puppet::Face.define :node_openstack, '0.0.1' do

  action :terminate do

    summary 'Terminate machine instance.'
    description <<-EOT
      Terminate the instance identified by <instance_id>.
    EOT

    arguments '<instance_id>'

    Puppet::CloudPack.add_platform_option(self)

    option '--force', '-f' do
      summary 'Forces termination of an instance.'
    end

    when_invoked do |server, options|
      options[:terminate_id] = 'instance-id'
      Puppet::CloudPack.terminate(server, options)
    end
  end
end
