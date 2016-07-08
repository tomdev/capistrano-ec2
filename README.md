# Capistrano::Ec2

Useful for dynamically building a list of Amazon EC2 instances to deploy to.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-ec2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-ec2

## Usage

**Requirements:**

Set the EC region in which your instances live in the Capistrano deploy configuration:

config/deploy.rb
```ruby
set :region, 'us-west-2'
```

Since it's a bad practice to have your credentials in source code, you should load them from default fog configuration file: ~/.fog. This file could look like this:

```
default:
  aws_access_key_id:     <YOUR_ACCESS_KEY_ID>
  aws_secret_access_key: <YOUR_SECRET_ACCESS_KEY>
```

**Usage:**

Tag your EC2 instances so you can target specific servers in your Capistrano configuration.

Here is how to target all `production` `application-servers`:

```ruby
for_each_ec2_server(ec2_env: "production", ec2_role: "application-server") do |ec2_server|
  server ec2_server.private_ip_address, user: 'deploy', roles: roles
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomdev/capistrano-ec2.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
