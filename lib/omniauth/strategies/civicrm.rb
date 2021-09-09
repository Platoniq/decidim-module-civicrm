# frozen_string_literal: true

require "omniauth-oauth2"
require "open-uri"

module OmniAuth
  module Strategies
    class Civicrm < OmniAuth::Strategies::OAuth2
      args [:client_id, :client_secret, :site]

      option :name, :civicrm
      option :site, nil
      option :client_options, {}

      uid do
        raw_info["sub"]
      end

      info do
        {
          name: extra[:contact][:display_name],
          nickname: raw_info["preferred_username"],
          email: raw_info["email"],
          image: raw_info["picture"]
        }
      end

      extra do
        civicrm_info
      end

      def client
        options.client_options[:site] = options.site

        locale_path_segment = "/#{request[:locale]}/"

        options.client_options[:authorize_url] = URI.join(options.site, locale_path_segment, "oauth2/authorize").to_s
        options.client_options[:token_url] = URI.join(options.site, locale_path_segment, "oauth2/token").to_s
        super
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def raw_info
        @raw_info ||= access_token.get("/oauth2/UserInfo").parsed
      end

      def civicrm_info
        @civicrm_info ||= ::Decidim::Civicrm::Api::FindUser.new(uid).result
      end
    end
  end
end
