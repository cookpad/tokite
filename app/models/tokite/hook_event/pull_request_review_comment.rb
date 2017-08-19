module Tokite
  module HookEvent
    class PullRequestReviewComment < BaseEvent
      def fields
        {
          event: "pull_request_review_comment",
          repo: hook_params[:repository][:full_name],
          body: hook_params[:comment][:body],
          user: hook_params[:comment][:user][:login],
        }
      end

      def notify?
        hook_params[:action] == "created"
      end

      def slack_text
        nil
      end

      def slack_attachment
        user = hook_params[:comment][:user][:login]
        line = hook_params[:comment][:position]
        path = hook_params[:comment][:path]
        footer_url = hook_params[:comment][:html_url]
        footer_text = "Comment by #{user} on line #{line} of #{path}"
        {
          fallback: "#{hook_params[:comment][:body]}\n#{footer_text}",
          text: hook_params[:comment][:body],
          footer: "<#{footer_url}|#{footer_text}>"
        }
      end
    end
  end
end
