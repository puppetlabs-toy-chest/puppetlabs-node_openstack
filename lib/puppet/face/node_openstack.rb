require 'puppet/face'

Puppet::Face.define(:node_openstack, '0.0.1') do
  copyright "Puppet Labs", 2011
  license   "Apache 2 license; see COPYING"

  option "--endpoint ENDPOINT" do
    summary 'Nova API server that services vm management requests'

    description <<-EOT
      Nova API server that services vm management requests
    EOT
  end

  summary "View and manage openstack nodes."
  description <<-'EOT'
    This subcommand provides a command line interface to work with Openstack
    machine instances.  The goal of these actions is to easily create new
    machines, install Puppet onto them, and tear them down when they're no longer
    required.
  EOT
end
