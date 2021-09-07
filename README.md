# Decidim::Civicrm

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-civicrm'
```

And then execute to install the gem:

    $ bundle install

And then run:

    $ rails g decidim:civicrm:install


## Configuration

Configure these values in your project's `config/secrets.yml` file:

```yaml
  omniauth:
    civicrm:
      enabled: true
      client_id: <%= ENV["CIVICRM_OAUTH_CLIENT_ID"] %>
      client_secret: <%= ENV["CIVICRM_OAUTH_CLIENT_SECRET"] %>
      site: <%= ENV["CIVICRM_OAUTH_SITE"] %>
```

and

```yaml
  civicrm:
    api:
      api_key: <%= ENV["CIVICRM_API_KEY"] %>
      key: <%= ENV["CIVICRM_API_SECRET"] %>
      url: <%= ENV["CIVICRM_API_URL"] %>
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Platoniq/decidim-module-decidim_civicrm.
