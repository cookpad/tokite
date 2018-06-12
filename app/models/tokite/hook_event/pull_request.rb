module Tokite
  module HookEvent
    class PullRequest < BaseEvent
      def fields
        {
          event: "pull_request",
          repo: hook_params[:repository][:full_name],
          title: hook_params[:pull_request][:title],
          body: hook_params[:pull_request][:body],
          user: hook_params[:pull_request][:user][:login],
        }
      end

      def notify?
        %w(opened).include?(hook_params[:action])
      end

      def slack_text
        "[#{hook_params[:repository][:full_name]}] Pull request submitted by <#{hook_params[:pull_request][:user][:html_url]}|#{hook_params[:pull_request][:user][:login]}>"
      end

      def slack_attachment
        {
          title: "##{hook_params[:pull_request][:number]} #{hook_params[:pull_request][:title]}",
          title_link: hook_params[:pull_request][:html_url],
          fallback: "#{hook_params[:pull_request][:title]}\n#{hook_params[:pull_request][:body]}",
          text: hook_params[:pull_request][:body] || "No description provided.",
          color: "good",
        }
      end
    end
  end
end
