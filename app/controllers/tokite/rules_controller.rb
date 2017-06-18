module Tokite
  class RulesController < ApplicationController
    def index
      if params[:user_id]
        @users = User.where(id: params[:user_id]).includes(:rules)
      else
        @users = User.all.includes(:rules)
      end
    end
  
    def new
      @rule = rule_user.rules.build
    end
  
    def create
      @rule = rule_user.rules.new(rule_params)
      if @rule.save
        redirect_to edit_user_rule_path(params[:user_id], @rule)
      else
        render "new"
      end
    end
  
    def edit
      @rule = rule_user.rules.find(params[:id])
    end
  
    def update
      @rule = rule_user.rules.find(params[:id])
      @rule.assign_attributes(rule_params)
      if @rule.save
        redirect_to edit_user_rule_path(params[:user_id], @rule)
      else
        render "edit"
      end
    end
  
    def destroy
      @rule = rule_user.rules.find(params[:id])
      @rule.destroy!
      redirect_to user_rules_path(params[:user_id])
    end
  
    private
  
    def rule_user
      @rule_user ||= User.find(params[:user_id])
    end
  
    def rule_params
      params.require(:rule).permit(:name, :query, :channel, :icon_emoji, :additional_text)
    end
  end
end
