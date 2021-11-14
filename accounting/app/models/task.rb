# frozen_string_literal: true

class Task < Sequel::Model
  plugin :association_dependencies

  many_to_one :user

  INITIAL_STATUS = 'bird_in_cage'
  DONE_STATUS = 'millet_in_bowl'

  def validate
    super

    validates_presence :title, message: I18n.t(:blank, scope: 'model.errors.task.title')
    validates_presence :jira_id, message: I18n.t(:blank, scope: 'model.errors.task.jira_id')
    validates_presence :gid, message: I18n.t(:blank, scope: 'model.errors.task.gid')
    validates_presence :status, message: I18n.t(:blank, scope: 'model.errors.task.status')
    validates_presence :cost, message: I18n.t(:blank, scope: 'model.errors.task.cost')
    validates_presence :compensation, message: I18n.t(:blank, scope: 'model.errors.task.compensation')
  end
end
