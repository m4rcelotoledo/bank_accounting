# frozen_string_literal: true

require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "active_job/railtie"
# require "active_storage/engine"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BankAccounting
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    config.active_support.to_time_preserves_timezone = :zone

    # Security configurations
    config.action_controller.permit_all_parameters = false
    config.action_controller.action_on_unpermitted_parameters = :raise

    # Disable detailed error messages in production
    config.consider_all_requests_local = false if Rails.env.production?

    # Force SSL in production
    config.force_ssl = true if Rails.env.production?

    # Autoload services
    config.autoload_paths += %W[#{config.root}/app/services]
  end
end
