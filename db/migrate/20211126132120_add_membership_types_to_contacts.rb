class AddMembershipTypesToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_civicrm_contacts, :membership_types, :jsonb
  end
end
