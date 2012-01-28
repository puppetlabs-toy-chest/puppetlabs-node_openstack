require 'puppet/cloudpack'
require 'puppet/face/node_openstack'

Puppet::Face.define :node_openstack, '0.0.1' do

  action :terminate do

    summary 'Terminate an OpenStack machine instance.'
    description <<-EOT
      Terminate the instance identified by <instance_id>.
    EOT

    arguments '<instance_id>'

    Puppet::CloudPack.add_terminate_options(self)

    when_invoked do |server, options|
      # right now this is hard coded
      Puppet::CloudPack.terminate(server, options, 'instance-id')
    end
  end
end
