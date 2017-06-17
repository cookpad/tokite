# frozen_string_literal: true

module Tokite
  class ShaController < ActionController::API
  
    def show
      revision = Revision.take
      if revision
        status = 200
      else
        revision = "REVISION_FILE_NOT_FOUND"
        status = 404
      end
      render plain: "#{revision}\n", status: status
    end
  end
end
