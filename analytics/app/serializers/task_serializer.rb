# frozen_string_literal: true

class TaskSerializer
  include JSONAPI::Serializer

  set_type :task
  attributes :title, :cost
end
