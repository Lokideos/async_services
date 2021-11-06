# frozen_string_literal: true

class User < Sequel::Model
  plugin :association_dependencies
  plugin :secure_password, include_validations: false
  plugin :uuid, field: :gid

  one_to_many :sessions, class: 'UserSession'

  add_association_dependencies sessions: :delete

  NAME_FORMAT = /\A\w+\z/.freeze
  ALLOWED_ROLES = %w(developer manager admin).freeze

  def validate
    super

    validates_presence :name, message: I18n.t(:blank, scope: 'model.errors.user.name')
    validates_format NAME_FORMAT, :name, message: I18n.t(:format, scope: 'model.errors.user.name')
    validates_presence :password, message: I18n.t(:blank, scope: 'model.errors.user.password') if new?
    validates_presence :password_digest, message: I18n.t(:blank, scope: 'model.errors.user.password') unless new?
    validates_includes ALLOWED_ROLES,
                       :role,
                       message: I18n.t(:bad_role,
                                       scope: 'model.errors.user.role',
                                       roles: ALLOWED_ROLES)
  end
end
