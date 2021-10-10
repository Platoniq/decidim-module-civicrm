class CreateDecidimCivicrmGroupParticipatorySpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_civicrm_group_participatory_spaces do |t|
      t.references :group, null: false, foreign_key: { to_table: :decidim_civicrm_groups }, index: { name: :index_civicrm_group_spaces_on_group_id }
      t.references :participatory_space, null: false, polymorphic: true, index: true, index: { name: :index_civicrm_group_spaces_on_space_id }

      t.timestamps

      t.index ["group_id", "participatory_space_type", "participatory_space_id"], name: "index_unique_civicrm_space_and_group", unique: true
    end
  end
end
