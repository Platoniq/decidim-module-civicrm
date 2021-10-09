# frozen_string_literal: true
# # frozen_string_literal: true

# Decidim::Verifications.register_workflow(:civicrm_groups) do |workflow|
#   workflow.admin_engine = Decidim::Civicrm::AdminEngine
#   workflow.action_authorizer = "Decidim::Civicrm::Verifications::GroupActionAuthorizer"

#   workflow.options do |options|
#     options.attribute :group_ids, type: :string
#   end
# end

# Decidim::Verifications.register_workflow(:civicrm_memberships) do |workflow|
#   workflow.admin_engine = Decidim::Civicrm::AdminEngine
#   workflow.action_authorizer = Decidim::Civicrm::Verifications::MembershipActionAuthorizer

#   workflow.options do |options|
#     options.attribute :membership_ids, type: :array
#   end
# end

# ActionView::Template::Error (undefined method `decidim_civicrm_groups' for #<Decidim::Verifications::Adapter:0x00007f96bc2ae090>
#   Did you mean?  decidim_admin_civicrm_groups
#                  decidim_civicrm_admin):
