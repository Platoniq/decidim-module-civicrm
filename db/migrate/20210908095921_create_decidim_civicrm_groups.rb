class CreateDecidimCivicrmGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_civicrm_groups do |t|
      t.integer :civicrm_group_id, null: false

      t.string :title, null: false
      t.string :description, null: false
      t.jsonb :extra, default: {}

      t.boolean :marked_for_deletion, default: false

      t.timestamps
    end
  end
end
