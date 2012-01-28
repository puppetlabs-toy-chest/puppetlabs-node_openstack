require 'spec_helper'
require 'puppet/cloudpack'

describe Puppet::Face[:node_openstack, :current] do

  let :options do
    {
      :platform => 'AWS',
      :endpoint => 'http://foo'
    }
  end

  let :action do
    :terminate
  end

  let :argument do
    'my_server'
  end

  # this will not work b/c it takes an argument
  it_behaves_like 'something that connects to openstack'

  it 'should require an argument' do
    expect do
      subject.terminate(options)
    end.should raise_error
  end

end

