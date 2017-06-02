class HooksController < ActionController::Base
  protect_from_forgery with: :null_session

  def create
    render plain: "ok"
  end
end