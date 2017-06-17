module Tokite
  module HookEvent
    class Issues < BaseEvent
      def fields
        {
          event: "issues",
          repo: hook_params[:repository][:full_name],
          title: hook_params[:issue][:title],
          body: hook_params[:issue][:body],
          user: hook_params[:issue][:user][:login],
        }
      end
  
      def notify?
        %w(opened).include?(hook_params[:action])
      end
  
      def slack_text
        "[#{hook_params[:repository][:full_name]}] Issue created by <#{hook_params[:issue][:user][:html_url]}|#{hook_params[:issue][:user][:login]}>"
      end
  
      def slack_attachment
        {
          title: "##{hook_params[:issue][:number]} #{hook_params[:issue][:title]}",
          title_link: hook_params[:issue][:html_url],
          fallback: "#{hook_params[:issue][:title]}\n#{hook_params[:issue][:body]}",
          text: hook_params[:issue][:body],
          color: "good",
        }
      end
    end
  end
end
