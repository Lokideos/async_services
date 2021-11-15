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

    def developer_balances
      select(:id, :balance)&.where(role: 'developer').reverse_order(:updated_at).all
    end

    def user_balance(id)
      select(:id, :balance)&.first(id: id)
    end
  end

  ALLOWED_ROLES = %w(developer manager admin).freeze

  def validate
    super

    validates_presence :gid, message: I18n.t(:blank, scope: 'model.errors.user.gid')
    validates_presence :role, message: I18n.t(:blank, scope: 'model.errors.user.role')
    validates_includes ALLOWED_ROLES,
                       :role,
                       message: I18n.t(:bad_role,
                                       scope: 'model.errors.user.role',
                                       roles: ALLOWED_ROLES)
    validates_presence :balance, message: I18n.t(:blank, scope: 'model.errors.user.balance')
  end
end
