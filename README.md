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

Configure these values in `spec/decidim_dummy_app/config/secrets.yml`:

```yaml
  omniauth:
    civicrm:
      enabled: true
      client_id: fake-civicrm-client-id
      client_secret: fake-civicrm-client-secret
      site: https://civicrm.site
```

and

```yaml
  civicrm:
    api:
      api_key: fake-civicrm-api-key
      key: fake-civicrm-api-secret
      url: https://api.base
```

TODO: Write development instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Platoniq/decidim-module-decidim_civicrm.
