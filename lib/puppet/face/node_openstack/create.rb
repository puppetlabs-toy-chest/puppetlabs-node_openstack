require 'puppet/cloudpack'
require 'puppet/face/node_openstack'

Puppet::Face.define :node_openstack, '0.0.1' do

  action :create do

    summary 'Create a new machine instance.'
    description <<-EOT
      Launches a new OpenStack machine instance and returns the
      machine's identifier.

      A newly created system may not be immediately ready after launch while
      it boots.

      If creation of the instance fails, Puppet will automatically clean up
      after itself and tear down the instance.
    EOT

    Puppet::CloudPack.add_platform_option(self)
    Puppet::CloudPack.add_floating_ip_option(self)
    Puppet::CloudPack.add_availability_zone_option(self)
    Puppet::CloudPack.add_image_option(self)
    # TODO I am not sure if subnet should be supported
    #Puppet::CloudPack.add_subnet_option(self)
    Puppet::CloudPack.add_group_option(self)

    option '--type=' do
      summary 'Type of instance.'
      description <<-EOT
        Type of instance to be launched. The type specifies characteristics that
        a machine will have, such as memory, processing power, storage,
        and IO performance.
      EOT

      required

      # TODO - I should be able to query the list of flavors to validate against

    end

    option '--keyname=' do
      summary 'The SSH key name that identifies the public key to be injected into the created instance.'
      description <<-EOT
        The identifier of the SSH public key to inject into the instance's
        authorized_keys file when the instance is created.

        This keyname should identify the public key that corresponds with the
        private key identified by the --keyfile option of the `node` subcommand's
        `install` action.

        You can use the `list_keynames` action to get a list of valid key pairs for the
        specified endpoint.
      EOT

      required

      before_action do |action, args, options|
        if Puppet::CloudPack.create_connection(options).key_pairs.get(options[:keyname]).nil?
          raise ArgumentError, "Unrecognized key name: #{options[:keyname]} (Suggestion: use the puppet node_openstack list_keynames action to find a list of valid key names for your account.)"
        end
      end
    end

    when_invoked do |options|
      # nova does not support tags
      options[:tags_not_supported] = true
      Puppet::CloudPack.create(options)
    end
  end
end
