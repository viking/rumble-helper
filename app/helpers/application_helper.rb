module ApplicationHelper
  def ui_icon(name, options = {})
    content_tag('span', nil, options.merge(:class => "ui-icon ui-icon-#{name}"))
  end
end
