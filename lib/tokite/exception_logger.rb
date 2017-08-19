module Tokite
  class ExceptionLogger
    def self.callbacks
      @callbacks ||= []
    end

    def self.configure(callback)
      callbacks << callback
    end

    def self.log(e, options = {})
      callbacks.each{|callback| callback.call(e, options) }
    end
  end
end
