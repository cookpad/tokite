module HookEvent
  class Issues < BaseEvent
    def target_texts
      [
        hook_params[:issue][:title],
        hook_params[:issue][:body],
        hook_params[:issue][:user][:login],
      ]
    end
  end
end
