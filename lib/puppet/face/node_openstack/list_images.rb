require 'puppet/cloudpack'
require 'puppet/face/node_openstack'

Puppet::Face.define :node_openstack, '0.0.1' do

  action :list_images do

    summary 'List available images.'
    description <<-EOT
      Obtains a list of images from the ec2 api endpoint
      and displays them on the console output. Only the images being managed
      by the specified api endpoint are listed.
    EOT

    Puppet::CloudPack.add_platform_option(self)

    when_invoked do |options|
      Puppet::CloudPack.create_connection(options).images
    end

    when_rendering :console do |value|
      value.collect do |image|
        "#{image.id}:\n" + image.attributes.collect do |field, val|
          if(val and val != [] and val != {} and field != :id)
            "  #{field}: #{val.inspect}"
          end
        end.compact.sort.join("\n")
      end.sort.join("\n")
    end

  end
end
