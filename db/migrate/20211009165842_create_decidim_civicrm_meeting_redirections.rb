class CreateDecidimCivicrmMeetingRedirections < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_civicrm_meeting_redirections do |t|
      t.references :decidim_meeting, null: false, index: { unique: true, name: "index_civicrm_meetings_redirections_unique" }
      t.references :decidim_organization, null: false, index: { name: "index_civicrm_meetings_redirections_organization" }
      t.boolean :active, null: false
      t.string :url

      t.timestamps
    end
  end
end
