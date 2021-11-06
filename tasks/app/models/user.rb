# frozen_string_literal: true

class User < Sequel::Model
  plugin :association_dependencies

  ALLOWED_ROLES = %w(developer manager admin).freeze

  def validate
    super

    validates_presence :gid, message: I18n.t(:blank, scope: 'model.errors.task.name')
    validates_presence :role, message: I18n.t(:blank, scope: 'model.errors.task.name')
    validates_includes ALLOWED_ROLES,
                       :role,
                       message: I18n.t(:bad_role,
                                       scope: 'model.errors.user.role',
                                       roles: ALLOWED_ROLES)
  end
end
