# frozen_string_literal: true

class UserSession < Sequel::Model
  many_to_one :user

  def validate
    super

    validates_presence :gid, message: I18n.t(:blank, scope: 'model.errors.user_session.gid')
  end
end
