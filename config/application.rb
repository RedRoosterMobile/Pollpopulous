require File.expand_path('../boot', __FILE__)

require 'rails/all'

# this is needed for scss font-url() to look in app/assets folder...
require 'sprockets/railtie'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pollpopulous
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # Autoload lib/ folder including all subdirectories
    config.autoload_paths += %W(#{config.root}/lib)

    config.assets.paths << Rails.root.join('vendor')

    # see: http://richardyuwono.org/post/85523208658/heroku-websocket-rails-rails-4
    config.middleware.delete 'Rack::Lock'

    config.generators do |g|
      g.test_framework :mini_test, :spec => true, :fixture => true
    end
  end
end
