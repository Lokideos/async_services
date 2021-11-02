# frozen_string_literal: true

namespace :db do
  desc 'Create database migration'
  task :create_migration, [:name] do |_task, args|
    version = DateTime.now.strftime("%Y%m%d%H%M%S")
    filepath = File.join(__dir__, '../../db/migrations', "#{version}_#{args.name}.rb")
    migration_boilerplate = <<~CODE
      # frozen_string_literal: true

      Sequel.migration do
        up do
        end

        down do
        end
      end
    CODE

    File.write(filepath, migration_boilerplate)
  end
end
