# frozen_string_literal: true

class Task < Sequel::Model
  plugin :association_dependencies
  plugin :uuid, field: :gid

  many_to_one :user

  dataset_module do
    def non_closed_tasks
      where(status: INITIAL_STATUS).all
    end
  end

  INITIAL_STATUS = 'in_progress'
  DONE_STATUS = 'done'

  def validate
    super

    validates_presence :title, message: I18n.t(:blank, scope: 'model.errors.task.name')
    validates_presence :description, message: I18n.t(:blank, scope: 'model.errors.task.password')
  end
end
