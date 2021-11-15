# frozen_string_literal: true

class Transaction < Sequel::Model
  plugin :association_dependencies
  plugin :uuid, field: :gid

  WITHDRAWAL = 'withdraw'
  DEPOSIT = 'deposit'

  many_to_one :user

  dataset_module do
    def user_daily_transactions(id)
      where(
        user_id: id,
        created_at: DateTime.yesterday..DateTime.now
      ).all
    end
  end

  def validate
    super

    validates_presence :type, message: I18n.t(:blank, scope: 'model.errors.transaction.type')
    validates_presence :amount, message: I18n.t(:blank, scope: 'model.errors.transaction.amount')
  end
end
