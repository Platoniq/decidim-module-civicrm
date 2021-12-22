# frozen_string_literal: true

namespace :civicrm do
  # invoke with 'bundle exec rake "civicrm:sync:groups"'

  namespace :sync do
    desc "Sync Civicrm Groups and all related membershipos with CiViCRM API"
    task groups: :environment do
      Decidim::Organization.find_each do |organization|
        Civicrm::SyncAllGroupsJob.perform_now(organization.id)
      end
    end
  end
end
