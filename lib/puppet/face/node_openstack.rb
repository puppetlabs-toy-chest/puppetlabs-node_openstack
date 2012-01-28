require 'puppet/face'

Puppet::Face.define(:node_openstack, '0.0.1') do
  copyright "Puppet Labs", 2011
  license   "Apache 2 license; see COPYING"

  option "--endpoint ENDPOINT" do

    summary 'Nova API server that services vm management requests'
    description <<-EOT
      Nova API server that services vm management requests.
      By default, this should be : http://your.api.server:8773/services/Cloud
    EOT

    required

  end

  summary "View and manage openstack nodes."
  description <<-'EOT'
    This subcommand provides a command line interface to manage Openstack
    machine instances. The goal of these actions is to easily create new
    machine and tear them down when they're no longer
    required.
  EOT
end
