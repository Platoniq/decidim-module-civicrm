# frozen_string_literal: true

require "decidim/dev/common_rake"
require "fileutils"

def install_module(path)
  templates_dir = "lib/generators/decidim/civicrm/templates"

  FileUtils.cp File.join(templates_dir, "decidim_civicrm.rb"), "spec/decidim_dummy_app/config/initializers/decidim_civicrm.rb", verbose: true

  Dir.chdir(path) do
    system("bundle exec rake decidim_civicrm:install:migrations")
    system("bundle exec rake db:migrate")
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  install_module("spec/decidim_dummy_app")
end

desc "Generates a development app."
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end

  install_module("development_app")
  seed_db("development_app")
end
