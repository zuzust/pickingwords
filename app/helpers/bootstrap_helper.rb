module BootstrapHelper

  # renders:
  # <a href='#' class='dropdown-toggle' data-toggle='dropdown'>
  #   title
  #   <b class='caret'></b>
  # </a>
  def menu_header(title)
    raw(
      %Q{
        <a href='#' class='dropdown-toggle' data-toggle='dropdown'>
          #{title}
          <b class='caret'></b>
        </a>
      }
    )
  end

  # renders:
  # <li>
  #   <a href='uri'>
  #     <i class='icon-type'></i>
  #     text
  #   </a>
  # </li>
  def menu_entry(text, uri, icon="", options={})
    icon_html = icon.blank? ? "" : content_tag(:i, '', class: icon) + " "

    content_tag :li do
      link_to uri, options do
        icon_html + text
      end
    end
  end

  # renders:
  # <li>
  #   <a href='uri' data-method='delete'>
  #     <i class='icon-type'></i>
  #     text
  #   </a>
  # </li>
  def logout_entry(text, uri, icon="")
    menu_entry text, uri, icon, method: 'delete'
  end

  # renders:
  # <li class='divider'></li>
  def menu_divider
    content_tag :li, '', class: 'divider'
  end

  # renders:
  # <li class='divider-vertical'></li>
  def menu_divider_v
    content_tag :li, '', class: 'divider-vertical'
  end

  # renders:
  # <a href='#' rel='tooltip' title='title' class='pw-help'>...</a>
  def tooltip(title, &block)
    link_to '#', rel: 'tooltip', title: title, class: 'pw-help' do
      yield
    end
  end

  # renders:
  # <span class='badge' data-badge='type'>text</span>
  def badge(text, type, klass="")
    klass = klass.blank? ? "badge" : "badge badge-#{klass}" 
    content_tag :span, text, class: klass, data: {badge: type}
  end

  # renders:
  # <span class='pw-header'>text</span>
  def header(text)
    content_tag :span, text, class: 'pw-header'
  end

end
