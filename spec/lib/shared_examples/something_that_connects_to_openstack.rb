shared_examples_for "something that connects to openstack" do

  # this shared behavior represents the options that
  # are common to all openstack faces: platform and endpoint

  # expects that the methods: action (name of action being tested
  # and options (default options) have been set

  describe 'when validating options:' do

    # used to specify rather or not the action call should
    # be passed an argument
    def call_action(options)
      if self.respond_to?(:argument)
        subject.send(action, argument, options)
      else
        subject.send(action, options)
      end
    end

    # used to conditionally specify rather of not the
    # call to Puppet::CloudPack#method expects an argument
    def expect_action(&block)
      if self.respond_to?(:argument)
        Puppet::CloudPack.expects(action).with do |argument, options|
          yield options
        end
      else
        Puppet::CloudPack.expects(action).with do |options|
          yield options
        end
      end
    end

    describe '#platform' do

      it 'should default to AWS' do
        expect_action do |options|
          options[:platform] == 'AWS'
        end
        options.delete(:platform)
        call_action(options)
      end

      it 'should accept AWS option' do
        expect_action do |options|
          options[:platform] == 'AWS'
        end
        options.merge!(:platform => 'AWS')
        call_action(options)
      end

      it 'should reject invalid options' do
        options.merge!(:platform => 'foo')
        expect do
          call_action(options)
        end.should raise_error(ArgumentError, /Platform must be one of the following/)
      end
    end

    describe '#endpoint' do

      it 'should require that an endpoint is specified' do
        options.delete(:endpoint)
        expect do
          call_action(options)
        end.should raise_error(ArgumentError, 'The following options are required: endpoint')
      end

      it 'should accept endpoints' do
        options.merge!(:endpoint => 'http://127.0.0.1:8773/services/Cloud')
        expect_action do |options|
          options[:endpoint] == 'http://127.0.0.1:8773/services/Cloud'
        end
        call_action(options)
      end
    end
  end
end
