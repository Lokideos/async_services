# frozen_string_literal: true

module ApplicationLoader
  extend self

  def load_app!
    init_config
    init_db
    require_app
    init_app
  end

  def reload_app!
    load_dir 'app/helpers'
    load_file 'config/application.rb'
    load_file 'app/services/basic_service.rb'
    load_dir('app', excluded_path: 'app/contracts')
  end

  def root
    File.expand_path('..', __dir__)
  end

  private

  def init_config
    require_file 'config/initializers/config'
  end

  def init_db
    require_file 'config/initializers/db'
  end

  def init_app
    require_dir 'config/initializers'
  end

  def require_app
    require_dir 'app/helpers'
    require_file 'config/application'
    require_file 'app/services/basic_service'
    require_dir 'app/contracts'
    require_dir 'app'
  end

  def require_file(path)
    require File.join(root, path)
  end

  def load_file(path)
    load File.join(root, path)
  end

  def require_dir(path)
    path = File.join(root, path)
    Dir["#{path}/**/*.rb"].sort.each { |file| require file }
  end

  def load_dir(path, excluded_path: '')
    path = File.join(root, path)
    files_to_exclude = excluded_path.present? ? Dir["#{File.join(root, excluded_path)}/**/*.rb"] : []

    (Dir["#{path}/**/*.rb"] - files_to_exclude).each { |file| load file }
  end
end
