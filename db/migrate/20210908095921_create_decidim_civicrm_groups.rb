class CreateDecidimCivicrmGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_civicrm_groups do |t|
      t.references :decidim_organization, foreign_key: { to_table: :decidim_organizations }, index: { name: :index_decidim_civicrm_groups_on_decidim_organization_id }

      t.integer :civicrm_group_id, null: false

      t.string :title
      t.string :description
      t.jsonb :extra, default: {}

      t.boolean :marked_for_deletion, default: false

      t.timestamps
    end
  end
end
