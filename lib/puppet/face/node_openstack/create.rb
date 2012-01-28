require 'puppet/cloudpack'
require 'puppet/face/node_openstack'

Puppet::Face.define :node_openstack, '0.0.1' do

  action :create do
    summary 'Create a new machine instance.'
    description <<-EOT
      This action launches a new OpenStack machine instance and returns the
      machines identifier.

      A newly created system may not be immediately ready after launch while
      it boots.

      If creation of the instance fails, Puppet will automatically clean up
      after itself and tear down the instance.
    EOT

    Puppet::CloudPack.add_platform_option(self)
    Puppet::CloudPack.add_region_option(self)
    Puppet::CloudPack.add_availability_zone_option(self)
    Puppet::CloudPack.add_image_option(self)
    Puppet::CloudPack.add_type_option(self)
    Puppet::CloudPack.add_keyname_option(self)
    # I am not sure if subnet is supported
    #Puppet::CloudPack.add_subnet_option(self)
    Puppet::CloudPack.add_group_option(self)

    when_invoked do |options|
      options[:tags_not_supported] = true
      Puppet::CloudPack.create(options)
    end
  end
end
