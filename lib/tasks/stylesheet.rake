namespace :tokite do
  namespace :stylesheet do
    desc "Download stylesheets under the vendor directory"
    task :install do
      vendor_dir = Tokite::Engine.root.join("vendor", "stylesheets", "tokite")
      rm_rf(vendor_dir)
      mkdir_p(vendor_dir)

      tmp_dir = Tokite::Engine.root.join("tmp")
      mkdir_p(tmp_dir)

      # Bulma
      version = "1.0.4"
      bulma_url = "https://github.com/jgthms/bulma/releases/download/#{version}/bulma-#{version}.zip"
      bulma_zip = tmp_dir.join("bulma.zip")
      bulma_dir = vendor_dir.join("bulma")
      mkdir_p(bulma_dir.join("sass"))
      sh "curl -sSfL -o '#{bulma_zip}' '#{bulma_url}'"
      sh "tar xf '#{bulma_zip}' --strip-components 2 -C '#{bulma_dir.join("sass")}' 'bulma/sass'"
      sh "tar xf '#{bulma_zip}' --strip-components 1 -C '#{bulma_dir}' 'bulma/LICENSE'"
    end
  end
end
