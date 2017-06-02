module Hook
  HOOKS = {
    "pull_request" => Hook::PullRequest,
    "issues" => Hook::Issues,
    "issue_comment" => Hook::IssueComment,
  }.freeze

  def self.fire!(github_event, hook_params)
    hook = HOOKS[github_event]
    hook&.fire!(hook_params)
  end
end