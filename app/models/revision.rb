class Revision
  REVISION_PATH = Rails.root.join("REVISION")

  def self.take
    return ENV["HEROKU_SLUG_COMMIT"] if ENV["HEROKU_SLUG_COMMIT"]
    return File.read(REVISION_PATH).chomp if File.exist?(REVISION_PATH)
  end
end