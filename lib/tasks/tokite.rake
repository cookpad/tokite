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
      tokite_schema_dir = app_path("schema/tokite")
      mkdir_p(tokite_schema_dir) unless Dir.exist?(tokite_schema_dir)

      schema_dir = app_path("schema")
      mkdir_p(schema_dir) unless Dir.exist?(schema_dir)

      Dir.glob("#{engine_path("schema")}/*").each do |src_path|
        basename = File.basename(src_path)
        next if basename == 'tokite'
        if File.exist?(File.join(tokite_schema_dir, basename))
          puts "Skip install schema #{src_path}"
        else
          puts "Install schema #{src_path}"
          cp src_path, tokite_schema_dir
          cp src_path, schema_dir
        end
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
