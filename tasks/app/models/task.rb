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

    validates_presence :title, message: I18n.t(:blank, scope: 'model.errors.task.title')
    validates_presence :jira_id, message: I18n.t(:blank, scope: 'model.errors.task.jira_id')
    errors.add(:title, I18n.t(:format, scope: 'model.errors.task.title')) if title_contains_brackets?
    validates_presence :description, message: I18n.t(:blank, scope: 'model.errors.task.password')
  end

  private

  def title_contains_brackets?
    (title&.split('') & %w[[ ]]).present?
  end
end
