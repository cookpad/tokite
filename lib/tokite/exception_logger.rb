module Tokite
  class ExceptionLogger
    def self.configure(logger)
      @logger = logger
    end

    def self.log(e)
      @logger&.log(e)
    end
  end
end
