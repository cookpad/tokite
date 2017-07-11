module Tokite
  class TransfersController < ApplicationController
    def new
      @transfer = Transfer.new(rule_id: params[:rule_id])
      @rule = @transfer.rule
      @users = User.where.not(id: @rule.user_id)
    end

    def create
      @transfer = Transfer.create!(rule_id: params[:rule_id], user_id: params[:transfer][:user_id])
      redirect_to user_path(@transfer.rule.user_id)
    end
  end
end
