module HookEvent
  class IssueComment < BaseEvent
    def fields
      {
        event: "issue_comment",
        repo: hook_params[:repository][:full_name],
        body: hook_params[:comment][:body],
        user: hook_params[:comment][:user][:login],
      }
    end

    def notify?
      %w(created).include?(hook_params[:action])
    end

    def slack_text
      "[#{hook_params[:repository][:full_name]}] New comment by #{hook_params[:comment][:user][:login]} on issue <#{hook_params[:comment][:html_url]}|##{hook_params[:issue][:number]}: #{hook_params[:issue][:title]}>"
    end

    def slack_attachment
      {
        fallback: hook_params[:comment][:body],
        text: hook_params[:comment][:body],
        color: "good",
      }
    end
  end
end
