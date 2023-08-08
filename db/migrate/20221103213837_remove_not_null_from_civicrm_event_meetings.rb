class RemoveNotNullFromCivicrmEventMeetings < ActiveRecord::Migration[6.0]
  def change
    change_column_null :decidim_civicrm_event_meetings, :decidim_meeting_id, true
    add_index :decidim_civicrm_event_meetings, ["civicrm_event_id", "decidim_organization_id"], name: "index_unique_civicrm_event_organization", unique: true
  end
end
