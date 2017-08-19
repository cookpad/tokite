module Tokite
  module HookEvent
    class PullRequestReview < BaseEvent
      def fields
        {
          event: "pull_request_review",
          repo: hook_params[:repository][:full_name],
          body: hook_params[:review][:body],
          user: hook_params[:review][:user][:login],
          review_state: hook_params[:review][:state],
        }
      end

      def notify?
        return false unless hook_params[:action] == "submitted"
        if hook_params[:review][:state] == "commented"
          hook_params[:review][:body]
        else
          true
        end
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
          when "requested_changes"
            "#{repo} #{user} requested changes #{title}"
        end
      end

      def slack_attachment
        return unless hook_params[:review][:body]
        case hook_params[:review][:state]
          when "commented"
          when "approved"
            color = "good"
          when "requested_changes"
            color = "warning"
        end
        {
          fallback: hook_params[:review][:body],
          text: hook_params[:review][:body],
          color: color,
        }
      end
    end
  end
end
