# frozen_string_literal: true

class User < Sequel::Model
  plugin :association_dependencies

  one_to_many :sessions, class: 'UserSession'
  one_to_many :tasks

  add_association_dependencies sessions: :delete

  dataset_module do
    def developer_ids
      where(role: 'developer').map(&:id)
    end

    def negative_balances
      where(role: 'developer').where{balance < 0}.all
    end

    def balances_total
      select(:balance)&.where(role: 'developer').sum(:balance)
    end
  end

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
