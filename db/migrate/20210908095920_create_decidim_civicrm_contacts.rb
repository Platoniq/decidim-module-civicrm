class CreateDecidimCivicrmContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_civicrm_contacts do |t|
      t.references :decidim_organization, foreign_key: { to_table: :decidim_organizations }, index: { name: :index_decidim_civicrm_contacts_on_decidim_organization_id }
      t.references :decidim_user, foreign_key: { to_table: :decidim_users }, index: { name: :index_decidim_civicrm_contacts_on_decidim_user_id }

      t.integer :civicrm_contact_id, null: false
      t.integer :civicrm_memberships, array: true, default: []

      t.jsonb :extra, default: {}

      t.boolean :marked_for_deletion, default: false

      t.timestamps
    end
  end
end
