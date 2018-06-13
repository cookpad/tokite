module Tokite
  module HookEvent
    class PullRequestReview < BaseEvent
      def fields
        {
          event: "pull_request_review",
          repo: hook_params[:repository][:full_name],
          body: hook_params[:review][:body] || "",
          user: hook_params[:review][:user][:login],
          review_state: hook_params[:review][:state],
        }
      end

      def notify?
        return false unless hook_params[:action] == "submitted"
        if hook_params[:review][:state] == "commented"
          return false unless hook_params[:review][:body].nil?
        true
      end

      def slack_text
        repo = "<#{hook_params[:repository][:html_url]}|[#{hook_params[:repository][:full_name]}]>"
        user = "<#{hook_params[:review][:user][:html_url]}|#{hook_params[:review][:user][:login]}>"
        title = "<#{hook_params[:pull_request][:html_url]}|##{hook_params[:pull_request][:number]} #{hook_params[:pull_request][:title]}>"
        case hook_params[:review][:state]
          when "commented"
            "#{repo} New comment by #{user} on pull request #{title}"
          when "approved"
            "#{repo} #{user} approved #{title}"
          when "changes_requested"
            "#{repo} #{user} requested changes #{title}"
        end
      end

      def slack_attachment
        case hook_params[:review][:state]
          when "commented"
          when "approved"
            color = "good"
          when "changes_requested"
            color = "warning"
        end
        {
          fallback: hook_params[:review][:body] || "",
          text: hook_params[:review][:body] || "",
          color: color,
        }
      end
    end
  end
end
