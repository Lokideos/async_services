# frozen_string_literal: true

I18n.load_path += Dir[ApplicationLoader.root.concat('/config/locales/**/*.yml')]
I18n.available_locales = %i(en ru)
I18n.default_locale = :en
