# frozen_string_literal: true

class Task < Sequel::Model
  plugin :association_dependencies

  many_to_one :user

  INITIAL_STATUS = 'bird_in_cage'
  DONE_STATUS = 'millet_in_bowl'

  dataset_module do
    def most_expensive_at_date(date)
      where(status: DONE_STATUS, updated_at: date).max_by(&:cost)
    end
  end

  def validate
    super

    validates_presence :title, message: I18n.t(:blank, scope: 'model.errors.task.title')
    validates_presence :gid, message: I18n.t(:blank, scope: 'model.errors.task.gid')
    validates_presence :status, message: I18n.t(:blank, scope: 'model.errors.task.status')
  end
end
