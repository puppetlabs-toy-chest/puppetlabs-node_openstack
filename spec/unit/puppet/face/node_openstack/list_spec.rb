require 'spec_helper'
require 'puppet/cloudpack'

describe Puppet::Face[:node_openstack, :current] do

  let :options do
    {
      :platform => 'AWS',
      :endpoint   => 'http://foo',
    }
  end

  let :action do
    :list
  end

  it_behaves_like 'something that connects to openstack'

end

