class CreateDecidimCivicrmGroupMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_civicrm_group_memberships do |t|
      t.references :decidim_organization, foreign_key: { to_table: :decidim_organizations }, index: { name: :index_decidim_civicrm_memberships_on_decidim_organization_id }

      t.references :group, foreign_key: { to_table: :decidim_civicrm_groups }, index: { name: :index_decidim_civicrm_group_memberships_on_group_id }
      t.references :contact, foreign_key: { to_table: :decidim_civicrm_contacts }, index: { name: :index_decidim_civicrm_group_memberships_on_contact_id }

      t.boolean :marked_for_deletion, default: false

      t.timestamps
    end
  end
end

