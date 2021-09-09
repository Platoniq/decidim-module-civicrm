# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/civicrm/version"

Gem::Specification.new do |s|
  s.version = Decidim::Civicrm.version
  s.authors = ["Vera Rojman", "Ivan Vergés"]
  s.email = ["vera@platoniq.net", "ivan@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/Platoniq/decidim-module-decidim_civicrm"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-civicrm"
  s.summary = "A Decidim module to connect with CiViCRM as OAUTH provider and perform verifications based on CiViCRM Contact attributes."
  s.description = "."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.require_paths = ["lib"]

  s.add_dependency "decidim", "~> #{Decidim::Civicrm.version}"
  s.add_dependency "decidim-core", "~> #{Decidim::Civicrm.version}"
  s.add_dependency "decidim-verifications", "~> #{Decidim::Civicrm.version}"

  s.add_development_dependency "decidim-admin", "~> #{Decidim::Civicrm.version}"
  s.add_development_dependency "decidim-dev", "~> #{Decidim::Civicrm.version}"
end
