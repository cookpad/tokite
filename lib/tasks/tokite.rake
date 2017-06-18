require 'pry'

namespace :tokite do
  namespace :ridgepole do
    def engine_path(file)
      Tokite::Engine.root.join(file).to_s
    end
  
    def app_path(file)
      Rails.root.join(file).to_s
    end
  
    def ridgepole_exec(*args)
      yml = Rails.root.join("config/database.yml").to_s
      sh "bundle", "exec", "ridgepole", "-c", yml, "-E", Rails.env, *args
    end
  
    desc "Export current schema"
    task :export do
      ridgepole_exec("--export", app_path("schema/Schemafile"), "--split")
    end
  
    desc "Apply Schemafile"
    task :apply do
      ridgepole_exec("--file", app_path("schema/Schemafile"), "-a")
    end
  
    desc "Apply Schemafile (dry-run)"
    task :"dry-run" do
      ridgepole_exec("--file", app_path("schema/Schemafile"), "-a", "--dry-run")
    end
  
    desc "Install schema"
    task :install do
      schema_dir = app_path("schema")
      mkdir(schema_dir) unless Dir.exist?(schema_dir)
      Dir.glob("#{engine_path("schema")}/*").each do |f|
        cp f, schema_dir
      end
    end
  end

  namespace :yarn do
    desc "Install yarn packages"
    task :install do
      sh "yarn", "add", "bulma"
    end
  end
end
