Puppet OpenStack Provisioner
========================

Puppet Module to launch and manage virtual machine instances using the Nova EC2 API.

This module has only been tested with Puppet 2.7.10.

Getting Started with OpenStack
===============================

Before launching instances with the OpenStack Provisioner module, you'll need to build
out a fully functional OpenStack instance.

Devstack is the quickest way to build out a functional OpenStack environment on a single
node for development.

 * [DevStack](http://devstack.org)

We are currently working on more robust modules that can be used to build out more complicated
multi-node environments for OpenStack. Anyone interested in collaboraing, can contact me at
dan <at> puppetlabs.com

 * [Puppet modules for OpenStack](https://github.com/puppetlabs/puppetlabs-openstack)

Once your OpenStack instance is built, obtain your Access Key ID and Access Key.  Place them into the
~/.fog file with the following syntax:

    :default:
      :aws_access_key_id: AKIAIXXXXXXXXXXXXXXX
      :aws_secret_access_key: jcjnhaXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXX

Once you have your Access key and ID in the ~/.fog file, you'll also need to
generate your SSH private key in Horizon (or just import the public key that you
wish to use).

You will need to have at least one valid image in order to start provisioning
instances. Devstack will automatically create an image for the micro kernel Cirros which
can be referenced as: ami-00000003.

You will need to know the url of the nova ec2 api server.
http://172.21.0.19:8773/services/Cloud

Finally, you'll probably want to configure the default security group to
allow SSH (Port 22) access.  This can be accomplished through the Horizon
console.  The install actions will fail if they cannot access the target system
on port 22 (SSH).

Required Gems
=============

 * guid (>= 0.1.1)
 * fog  (>=1.0.0)
 # TODO - cloud provisioner needs to be installed

Launching EC2 Instances
=======================

With your EC2 credentials placed in ~/.fog and your SSH private key available
on your system, you may launch a new instance with this module installed using
the following single command:

    $ puppet node_openstack create --image=ami-00000003 --endpoint=http://172.21.0.19:8773/services/Cloud --keyname=dans_key --type m1.tiny
    notice: Creating new instance ...
    notice: Creating new instance ... Done
    notice: Launching server i-00000002 ...
    ##############
    notice: Server i-00000002 is now launched
    notice: Server i-00000002 public dns name: server-2
    server-2

Once launched, you should be able to SSH to the new system using the private
key associated with the previously specified keyname.

# TODO - what should the networking recommendation be?
# for my example, I just set up a route through the single managed node
# so that I could access the nodes using their internal IPs

    $ ssh cirros@10.0.0.3
    The authenticity of host '10.0.0.3 (10.0.0.3)' can't be established.
    RSA key fingerprint is be:52:5e:78:79:39:f5:a3:d9:79:f7:35:59:aa:b7:b6.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '10.0.0.3' (RSA) to the list of known hosts.
    $ quit

Finally, you're able to install Puppet or Puppet Enterprise on the newly
launched system:

    $ puppet node install --login cirros --keyfile ~/.ssh/dans_key.pem 10.0.0.3
    notice: Waiting for SSH response ...
    notice: Waiting for SSH response ... Done
    notice: Installing Puppet ...
    66421292-9dee-7f41-624e-6ad2c50d78c1

If you need more detailed information, please use the --verbose and --debug
options to get more detailed output from the command.

As we can see, this installs Puppet using ruby gems:

    $ ssh root@ec2-107-20-18-142.compute-1.amazonaws.com puppet --version
    2.6.4

Puppet Installation
===================

The following installation scripts are available to install puppet on a target
system.  These script are appropriate values for the --install-script option to
the puppet node install action.

 * gems (default) - Installs Puppet and Facter from RubyGems.

 * puppet-enterprise - Installs Puppet by uploading a copy of the puppet
enterpise tarball from your workstation to the target node along with an
automated answers file.

 * puppet-enterprise-s3 - Installs Puppet by downloading a copy of Puppet
Enterprise 1.1 from Puppet Labs.  This may be much faster than the
puppet-enterprise script if you have limited upload bandwidth.



# TODO I may need to update this doc

Getting Started
===============

 * [Getting Started With Cloud Provisioner](http://docs.puppetlabs.com/guides/cloud_pack_getting_started.html)


Reporting Issues
----------------

Please report any problems you have with the OpenStack Provisioner module in the project page issue tracker at:

 * [OpenStack integration Issues](http://projects.puppetlabs.com/projects/openstack/issues)
