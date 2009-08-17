module DashboardHelper
  def ui_icon(name)
    content_tag('span', nil, :class => "ui-icon ui-icon-#{name}")
  end
end
