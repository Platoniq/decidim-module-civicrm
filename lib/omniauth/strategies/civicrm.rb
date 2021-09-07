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
          name: full_info[:civicrm][:contact][:display_name],
          nickname: full_info["preferred_username"],
          email: full_info["email"],
          image: full_info["picture"]
        }
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

      def full_info
        @full_info ||= raw_info.merge(civicrm: civicrm_info)
      end

      def civicrm_info
        ::Decidim::Civicrm::Api::FindUser.new(uid).result
      end
    end
  end
end
