require 'fog/aws'

module Capistrano
  class Configuration
    def for_each_ec2_server(ec2_env:, ec2_role:, &block)
      ec2 = Fog::Compute.new(provider: 'AWS', region: fetch(:region))

      filters = { "tag:ec2_env" => ec2_env, "tag:role" => ec2_role }

      ec2.servers.all(filters).map.with_index do |ec2_server, index|
        yield ec2_server, index
      end
    end
  end

  module DSL
    module Env
      def_delegators :env, :for_each_ec2_server
    end
  end
end
