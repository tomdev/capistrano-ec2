require 'fog/aws'
require 'forwardable'

module Capistrano
  class Configuration
    def for_each_ec2_server(ec2_env:, ec2_role:, &block)
      filters = {
        'tag:ec2_env' => ec2_env,
        'tag:role' => ec2_role,
        'instance-state-name': 'running'
      }

      ec2.servers.all(filters).map.with_index do |ec2_server, index|
        next unless ec2_server.ready?

        yield ec2_server, index
      end
    end

    private

    def ec2
      @ec2 ||= Fog::Compute.new(fog_arguments)
    end

    def fog_arguments
      default_options = {
        provider: 'AWS',
        region: region,
      }

      if use_iam_profile
        default_options.merge(iam_profile_options)
      else
        default_options.merge(access_key_options)
      end
    end

    def region
      fetch(:region)
    end

    def use_iam_profile
      fetch(:use_iam_profile, false)
    end

    def iam_profile_options
      { use_iam_profile: true }
    end

    def access_key_options
      {
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        aws_session_token: ENV['AWS_SESSION_TOKEN'],
      }
    end
  end

  module DSL
    module Env
      extend Forwardable
      def_delegators :env, :for_each_ec2_server
    end
  end
end
