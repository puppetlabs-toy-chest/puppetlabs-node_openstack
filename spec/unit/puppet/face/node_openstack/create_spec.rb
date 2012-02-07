require 'spec_helper'

describe Puppet::Face[:node_openstack, :current] do
  before :all do
    data = Fog::Compute::AWS::Mock.data['us-east-1'][Fog.credentials[:aws_access_key_id]]
    data[:images]['ami-12345'] = { 'imageId' => 'ami-12345' }
    data[:key_pairs]['some_keypair'] = { 'keyName' => 'some_keypair' }
  end

  let :options do
    {
      :platform => 'AWS',
      :image    => 'ami-12345',
      :type     => 'm1.small',
      :keyname  => 'some_keypair',
      :endpoint => 'http://foo'
    }
  end

  let :action do
    :create
  end

  # verify that it accepts platform and endpoint
  it_behaves_like "something that connects to openstack"

  it 'should pass an option to indicate that it does not support tags' do
    Puppet::CloudPack.expects(:create).with do |options|
      options[:tags_not_supported]
    end
    subject.create(options)
  end

  describe 'required options' do
    ['type', 'keyname', 'image'].each do |opt|
      it "should fail if #{opt} is not provided" do
        options.delete(opt.to_sym)
        expect do
          subject.create(options)
        end.should raise_error(ArgumentError, "The following options are required: #{opt}")
      end
    end
  end

  describe 'optional options' do
    ['group', 'availability_zone'].each do |opt|
      it "should not fail if option: #{opt} is not provided" do
        options.delete(opt.to_sym)
        Puppet::CloudPack.expects(:create).with do |options|
          ! options[opt.to_sym]
        end
        subject.create(options)
      end
    end
  end

  describe 'when setting options' do
    {
      'type'              => 'x1.large',
      'keyname'           => 'some_keypair',
      'image'             => 'ami-12345',
      'group'             => ['default'],
      'availability_zone' => 'zone_1'
    }.each do |k,v|
      it "should be possible to set option: #{k}" do
        options.merge!(k.to_sym => v)
        Puppet::CloudPack.expects(:create).with do |options|
          options[k.to_sym] == v
        end
        subject.create(options)
      end
    end
  end

  describe 'when setting invalid options' do
    {
      'keyname'           => 'bad_key',
      'image'             => 'bad_ami-00000001',
    }.each do |k,v|
      it "should raise an error: #{k}" do
        options.merge!(k.to_sym => v)
        expect do
          subject.create(options)
        end.should raise_error
      end
    end
  end
end
