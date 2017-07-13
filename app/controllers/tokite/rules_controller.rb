module Tokite
  class RulesController < ApplicationController
    def index
      @users = User.all.includes(:rules)
    end
  
    def new
      @rule_user = User.find(params[:user_id])
      @rule = @rule_user.rules.build
    end
  
    def create
      @rule_user = User.find(params[:user_id])
      @rule = @rule_user.rules.new(rule_params)
      if @rule.save
        flash[:info] = "Rule created."
        redirect_to edit_rule_path(@rule)
      else
        render "new"
      end
    end
  
    def edit
      @rule_user = nil
      @rule = Rule.find(params[:id])
    end
  
    def update
      @rule = Rule.find(params[:id])
      @rule.assign_attributes(rule_params)
      if @rule.save
        flash[:info] = "Rule updated."
        redirect_to edit_rule_path(@rule)
      else
        render "edit"
      end
    end
  
    def destroy
      @rule = Rule.find(params[:id])
      @rule.destroy!
      flash[:info] = "Rule deleted."
      redirect_to user_rules_path(params[:user_id])
    end

    private

    def rule_params
      params.require(:rule).permit(:name, :query, :channel, :icon_emoji, :additional_text)
    end
  end
end
