def ridgepole_exec(args)
  env = ENV.fetch("RAILS_ENV", "development")
  sh "bundle", "exec", "ridgepole", "-c", "config/database.yml", "-E", env, *args
end

namespace :ridgepole do
  desc "Export current schema"
  task :export do
    ridgepole_exec(%w(--export db/Schemafile --split))
  end

  desc "Apply Schemafile"
  task :apply do
    ridgepole_exec(%w(--file db/Schemafile -a))
  end

  desc "Apply Schemafile (dry-run)"
  task :"dry-run" do
    ridgepole_exec(%w(--file db/Schemafile -a --dry-run))
  end
end
