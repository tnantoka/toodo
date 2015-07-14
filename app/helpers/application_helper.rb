module ApplicationHelper
  def spinner(text = nil)
    html ="#{icon("spinner fa-fw fa-pulse")}"
    html << " #{text}" if text.present?
    html
  end

  def home?
    controller_name == 'welcome' && action_name == 'index'
  end
end
