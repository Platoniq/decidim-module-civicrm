Decidim CiviCRM integration module
==================================

This module provides certain integrations in order to use [CiviCRM](https://civicrm.org/) with Decidim.

Currently, the implementation supported is using CiviCRM 5.3 with Drupal 7.8.

Features:
--------

- Omniauth integration (aka: "Login with CiviCRM")
- Verification handler for all users logged via Omniauth. Handler: `civicrm`
- Verification handler for every group available in CiviCRM (and intelligent groups). Handler: `groups`
- Contact & groups synchronization to internal Rails models
- Administrator interface to enable which user/groups must be synchronized


Install
-------

Add into the `Gemfile`

```ruby
gem "decidim-civicrm", git: "https://github.com/Platoniq/decidim-module-civicrm", branch: "main"

```

Install dependencies:

```
bundle
```

Install (and run) migrations:


```
bundle exec rails decidim_civicrm:install:migrations
bundle exec rails db:migrate

```


## Configuration


Customize your integration by creating an initializer (ie: `config/initializes/decidim_civicrm.rb`) and set some of the variables:

```ruby
# config/initializers/decidim_civicrm.rb

Decidim::Civicrm.configure do |config|
  # Configure api credentials
  config.api =   {
    key: Rails.application.secrets.dig(:civicrm, :api, :key),
    secret: Rails.application.secrets.dig(:civicrm, :api, :secret),
    url: Rails.application.secrets.dig(:civicrm, :api, :url)
  }

  # Configure omniauth secrets
  config.omniauth =   {
    client_id: Rails.application.secrets.dig(:omniauth, :civicrm, :client_id),
    client_secret: Rails.application.secrets.dig(:omniauth, :civicrm, :client_secret),
    site: Rails.application.secrets.dig(:omniauth, :civicrm, :site)
  }

  # whether to send notifications to user when they auto-verified or not:
  config.send_verification_notifications = false

  # Optional: enable or disable verification methods (all enableD by default)
  config.authorizations = [:civicrm, :civicrm_groups]
end


```


TODO: Write development instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Platoniq/decidim-module-civicrm.
